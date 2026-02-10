/**
 * @file 主页模块
 * @description 实现 FeatureModule 接口，提供模块自动注册
 * @author JunBin.Yang
 */

import { Container } from '@core/di';
import { FeatureModule, RouteRegistry, ModuleContext } from '@core/module';
import { NavigationService } from '@core/navigation';
import { MainRoutes, IMainNavSvc, MAIN_NAV_SVC_KEY } from '@shared/contracts';
import { MainNavWrapper } from './navigation/HomeNav';
import { MainNavSvcImpl } from './services/MainNavSvcImpl';
import { Logger } from '@core/util';

/**
 * 主页模块
 * 实现 FeatureModule 接口，支持自动注册
 */
export class MainModule implements FeatureModule {
  /**
   * 模块唯一标识
   */
  readonly moduleId: string = 'main';

  /**
   * 模块名称
   */
  readonly moduleName: string = '主页模块';

  /**
   * 模块版本
   */
  readonly version: string = '1.0.0';

  /**
   * 模块依赖
   * 用于确定多个功能包先后加载顺序
   */
  readonly dependencies: string[] = [];

  /**
   * 注册 DI 服务
   * @param container DI 容器
   */
  registerServices(container: Container): void {
    // 注册本模块的导航服务
    container.register<IMainNavSvc>(MAIN_NAV_SVC_KEY, () => new MainNavSvcImpl());
  }

  /**
   * 注册路由
   * @param registry 路由注册器
   */
  registerRoutes(registry: RouteRegistry): void {
    // 注册首页路由
    registry.register(MainRoutes.Main, MainNavWrapper);
  }

  /**
   * 注册路由守卫
   * @param navigationService 导航服务
   */
  registerGuards(navigationService: NavigationService): void {
    // 主页模块不需要额外的守卫
  }

  /**
   * 模块初始化
   * @param context 模块上下文
   */
  async onInit(context: ModuleContext): Promise<void> {
    Logger.info(`[MainModule] 模块初始化完成: ${this.moduleName} v${this.version}`);
  }

  /**
   * 模块销毁
   */
  onDestroy(): void {
    Logger.info(`[MainModule] 模块已销毁: ${this.moduleName}`);
  }
}

/**
 * 创建主页模块实例
 */
export function createMainModule(): MainModule {
  return new MainModule();
}
