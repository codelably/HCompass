/**
 * @file 功能模块接口
 * @description 定义功能模块的标准接口
 * @author JunBin.Yang
 */

import { Container } from '@core/di';
import { RouteBuild, NavigationService } from '@core/navigation';

/**
 * 路由注册器接口
 */
export interface RouteRegistry {
  /**
   * 注册路由
   * @param name 路由名称
   * @param builder 路由构建器
   */
  register(name: string, builder: WrappedBuilder<[]>): void;

  /**
   * 获取路由构建器
   * @param name 路由名称
   * @returns 路由构建器
   */
  getBuilder(name: string): WrappedBuilder<[]> | undefined;
}

/**
 * 默认路由注册器实现
 * 基于 RouteBuild 的适配器
 */
export class DefaultRouteRegistry implements RouteRegistry {
  register(name: string, builder: WrappedBuilder<[]>): void {
    RouteBuild.register(name, builder);
  }

  getBuilder(name: string): WrappedBuilder<[]> | undefined {
    return RouteBuild.getBuilder(name);
  }
}

/**
 * 模块上下文
 * 提供模块初始化时所需的依赖
 */
export interface ModuleContext {
  /**
   * DI 容器
   */
  container: Container;

  /**
   * 路由注册器
   */
  routeRegistry: RouteRegistry;

  /**
   * 导航服务（可选，用于注册守卫）
   */
  navigationService?: NavigationService;
}

/**
 * 功能模块接口
 * 所有功能包必须实现此接口
 */
export interface FeatureModule {
  /**
   * 模块唯一标识
   */
  readonly moduleId: string;

  /**
   * 模块名称（用于显示）
   */
  readonly moduleName?: string;

  /**
   * 模块版本
   */
  readonly version?: string;

  /**
   * 模块依赖的其他模块 ID 列表
   */
  readonly dependencies?: string[];

  /**
   * 注册 DI 服务
   * @param container DI 容器
   */
  registerServices?(container: Container): void;

  /**
   * 注册路由
   * @param registry 路由注册器
   */
  registerRoutes?(registry: RouteRegistry): void;

  /**
   * 注册路由守卫
   * @param navigationService 导航服务
   */
  registerGuards?(navigationService: NavigationService): void;

  /**
   * 模块初始化
   * 在所有注册完成后调用
   * @param context 模块上下文
   */
  onInit?(context: ModuleContext): Promise<void> | void;

  /**
   * 模块销毁
   */
  onDestroy?(): void;
}

/**
 * 模块元数据
 */
export interface ModuleMetadata {
  /**
   * 模块 ID
   */
  moduleId: string;

  /**
   * 模块名称
   */
  moduleName?: string;

  /**
   * 模块版本
   */
  version?: string;

  /**
   * 依赖模块
   */
  dependencies?: string[];
}
