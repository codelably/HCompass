/**
 * @file 示例模块
 * @description 实现 FeatureModule 接口，提供框架功能演示
 * @author JunBin.Yang
 */

import { Container } from '@core/di';
import { FeatureModule, RouteRegistry, ModuleContext } from '@core/module';
import { NavigationService } from '@core/navigation';
import { ACCOUNT_STORE_REPOSITORY_KEY, DEMO_NAV_SVC_KEY,
  IAccountStoreRepository,
  IDemoNavSvc } from '@shared/contracts';
import { RouteGraph } from './navigation/RouteGraph';
import { AccountStoreRepositoryImpl } from './services/AccountStoreRepositoryImpl';
import { DemoNavSvcImpl } from './services/DemoNavSvcImpl';

/**
 * 示例模块
 * 实现 FeatureModule 接口，支持自动注册
 */
export class DemoModule implements FeatureModule {
  /**
   * 模块唯一标识
   */
  readonly moduleId: string = 'demo';

  /**
   * 模块名称
   */
  readonly moduleName: string = '示例模块';

  /**
   * 模块版本
   */
  readonly version: string = '1.0.0';

  /**
   * 模块依赖
   */
  readonly dependencies: string[] = [];

  /**
   * 注册 DI 服务
   * @param container DI 容器
   */
  registerServices(container: Container): void {
    // 注册本模块服务
    container.register<IDemoNavSvc>(DEMO_NAV_SVC_KEY, () => new DemoNavSvcImpl());
    container.register<IAccountStoreRepository>(ACCOUNT_STORE_REPOSITORY_KEY, () => new AccountStoreRepositoryImpl());
  }

  /**
   * 注册路由
   * @param registry 路由注册器
   */
  registerRoutes(registry: RouteRegistry): void {
    RouteGraph.register(registry);
  }

  /**
   * 注册路由守卫
   * @param navigationService 导航服务
   */
  registerGuards(navigationService: NavigationService): void {
    // 示例模块不需要额外的守卫
  }

  /**
   * 模块初始化
   * @param context 模块上下文
   */
  async onInit(context: ModuleContext): Promise<void> {
    console.info(`[DemoModule] 模块初始化完成: ${this.moduleName} v${this.version}`);
  }

  /**
   * 模块销毁
   */
  onDestroy(): void {
    console.info(`[DemoModule] 模块已销毁: ${this.moduleName}`);
  }
}

/**
 * 创建示例模块实例
 */
export function createDemoModule(): DemoModule {
  return new DemoModule();
}
