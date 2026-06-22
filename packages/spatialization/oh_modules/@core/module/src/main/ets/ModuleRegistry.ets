/**
 * @file 模块注册器
 * @description 管理功能模块的注册、依赖解析和初始化
 * @author JunBin.Yang
 */

import { Container, CoreServiceKeys, getContainer } from '@core/di';
import { NavigationService } from '@core/navigation';
import { FeatureModule, ModuleContext, RouteRegistry, DefaultRouteRegistry } from './FeatureModule';
import { Logger } from '@core/util';

const TAG: string = 'ModuleRegistry';

/**
 * 模块状态
 */
export enum ModuleState {
  /**
   * 已注册，未初始化
   */
  REGISTERED = 'registered',

  /**
   * 正在初始化
   */
  INITIALIZING = 'initializing',

  /**
   * 已初始化
   */
  INITIALIZED = 'initialized',

  /**
   * 初始化失败
   */
  FAILED = 'failed'
}

/**
 * 模块信息
 */
interface ModuleInfo {
  module: FeatureModule;
  state: ModuleState;
  error?: Error;
}

/**
 * 模块注册器配置
 */
export interface ModuleRegistryConfig {
  /**
   * DI 容器
   */
  container?: Container;

  /**
   * 路由注册器
   */
  routeRegistry?: RouteRegistry;

  /**
   * 是否启用日志
   */
  enableLog?: boolean;
}

/**
 * 模块注册器
 * 负责管理所有功能模块的生命周期
 */
export class ModuleRegistry {
  /**
   * 已注册的模块
   */
  private modules: Map<string, ModuleInfo> = new Map();

  /**
   * DI 容器
   */
  private container: Container;

  /**
   * 路由注册器
   */
  private routeRegistry: RouteRegistry;

  /**
   * 是否启用日志
   */
  private enableLog: boolean;

  /**
   * 是否已启动
   */
  private bootstrapped: boolean = false;

  /**
   * 构造函数
   * @param config 配置选项
   */
  constructor(config?: ModuleRegistryConfig) {
    this.container = config?.container ?? getContainer();
    this.routeRegistry = config?.routeRegistry ?? new DefaultRouteRegistry();
    this.enableLog = config?.enableLog !== false;
  }

  /**
   * 注册模块
   * @param module 功能模块
   */
  register(module: FeatureModule): void {
    if (this.modules.has(module.moduleId)) {
      this.log(`Module already registered: ${module.moduleId}`);
      return;
    }

    this.modules.set(module.moduleId, {
      module,
      state: ModuleState.REGISTERED
    });

    this.log(`Module registered: ${module.moduleId}`);
  }

  /**
   * 批量注册模块
   * @param modules 功能模块数组
   */
  registerAll(modules: FeatureModule[]): void {
    for (const module of modules) {
      this.register(module);
    }
  }

  /**
   * 启动所有模块
   * 按依赖顺序初始化
   */
  async bootstrap(): Promise<void> {
    if (this.bootstrapped) {
      this.log('Modules already bootstrapped');
      return;
    }

    this.log('Starting module bootstrap...');

    // 获取拓扑排序后的模块列表
    const sortedModules = this.topologicalSort();

    // 依次初始化模块
    for (const moduleId of sortedModules) {
      await this.initializeModule(moduleId);
    }

    this.bootstrapped = true;
    this.log('Module bootstrap completed');
  }

  /**
   * 初始化单个模块
   * @param moduleId 模块 ID
   */
  private async initializeModule(moduleId: string): Promise<void> {
    const info = this.modules.get(moduleId);
    if (!info) {
      throw new Error(`Module not found: ${moduleId}`);
    }

    if (info.state === ModuleState.INITIALIZED) {
      return;
    }

    if (info.state === ModuleState.INITIALIZING) {
      throw new Error(`Circular dependency detected: ${moduleId}`);
    }

    info.state = ModuleState.INITIALIZING;
    this.log(`Initializing module: ${moduleId}`);

    try {
      const module = info.module;

      // 1. 注册服务
      if (module.registerServices) {
        module.registerServices(this.container);
        this.log(`  - Services registered for: ${moduleId}`);
      }

      // 2. 注册路由
      if (module.registerRoutes) {
        module.registerRoutes(this.routeRegistry);
        this.log(`  - Routes registered for: ${moduleId}`);
      }

      // 3. 注册守卫
      const navigationService = this.container.tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
      if (module.registerGuards && navigationService) {
        module.registerGuards(navigationService);
        this.log(`  - Guards registered for: ${moduleId}`);
      }

      // 4. 调用初始化钩子
      if (module.onInit) {
        const context: ModuleContext = {
          container: this.container,
          routeRegistry: this.routeRegistry,
          navigationService: navigationService
        };
        await module.onInit(context);
        this.log(`  - onInit completed for: ${moduleId}`);
      }

      info.state = ModuleState.INITIALIZED;
      this.log(`Module initialized: ${moduleId}`);
    } catch (error) {
      info.state = ModuleState.FAILED;
      info.error = error instanceof Error ? error : new Error(String(error));
      this.logError(`Module initialization failed: ${moduleId}, error: ${info.error.message}`);
      throw info.error;
    }
  }

  /**
   * 拓扑排序
   * 按依赖关系排序模块
   * @returns 排序后的模块 ID 列表
   */
  private topologicalSort(): string[] {
    const result: string[] = [];
    const visited = new Set<string>();
    const visiting = new Set<string>();

    const visit = (moduleId: string) => {
      if (visited.has(moduleId)) {
        return;
      }

      if (visiting.has(moduleId)) {
        throw new Error(`Circular dependency detected: ${moduleId}`);
      }

      visiting.add(moduleId);

      const info = this.modules.get(moduleId);
      if (info?.module.dependencies) {
        for (const dep of info.module.dependencies) {
          if (this.modules.has(dep)) {
            visit(dep);
          } else {
            this.log(`Warning: Dependency not found: ${dep} (required by ${moduleId})`);
          }
        }
      }

      visiting.delete(moduleId);
      visited.add(moduleId);
      result.push(moduleId);
    };

    for (const moduleId of this.modules.keys()) {
      visit(moduleId);
    }

    return result;
  }

  /**
   * 获取模块状态
   * @param moduleId 模块 ID
   * @returns 模块状态
   */
  getModuleState(moduleId: string): ModuleState | undefined {
    return this.modules.get(moduleId)?.state;
  }

  /**
   * 获取所有已注册的模块 ID
   * @returns 模块 ID 列表
   */
  getModuleIds(): string[] {
    return Array.from(this.modules.keys());
  }

  /**
   * 获取模块数量
   * @returns 模块数量
   */
  get size(): number {
    return this.modules.size;
  }

  /**
   * 检查是否已启动
   * @returns 是否已启动
   */
  isBootstrapped(): boolean {
    return this.bootstrapped;
  }

  /**
   * 销毁所有模块
   */
  destroy(): void {
    for (const entry of this.modules.entries()) {
      const moduleId = entry[0];
      const info = entry[1];
      if (info.module.onDestroy) {
        try {
          info.module.onDestroy();
          this.log(`Module destroyed: ${moduleId}`);
        } catch (error) {
          this.logError(`Module destroy failed: ${moduleId}`);
        }
      }
    }

    this.modules.clear();
    this.bootstrapped = false;
    this.log('All modules destroyed');
  }

  /**
   * 记录日志
   */
  private log(message: string): void {
    if (this.enableLog) {
      Logger.info(message, TAG);
    }
  }

  /**
   * 记录错误日志
   */
  private logError(message: string): void {
    Logger.error(message, TAG);
  }
}
