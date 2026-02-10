import { CoreServiceKeys, getContainer } from '@core/di';
import { getModuleRegistry } from '@core/module';
import { NAV_PATH_STACK_KEY, RouteBuild, NavigationService } from '@core/navigation';
import { NetworkConfig } from "@core/network";
import { MainPage } from '@package/main';

/**
 * @file 挂载全局导航栈
 * @description 应用根导航容器，集成新框架导航服务
 * @author Joker.X
 */
@ComponentV2
export struct NavigationHost {
  /**
   * 导航栈
   */
  @Provider(NAV_PATH_STACK_KEY)
  navPathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    // 获取 DI 容器
    const container = getContainer();
    let enableNavigationServiceLog = false;
    if (container.has(CoreServiceKeys.ConfigManager)) {
      const config = container.resolve<NetworkConfig>(CoreServiceKeys.ConfigManager);
      enableNavigationServiceLog = config.enableLog ?? false;
    }
    container.register<NavigationService>(
      CoreServiceKeys.NavigationService,
      () => new NavigationService(this.navPathStack, enableNavigationServiceLog)
    );

    const module = getModuleRegistry();
    if(!module.isBootstrapped()) {
      module.bootstrap();
    }
  }

  /**
   * 导航目标构建器
   * @param name 路由名称
   * @returns 路由构建器
   */
  @Builder
  PagesMap(name: string) {
    if (RouteBuild.getBuilder(name) !== undefined) {
      (RouteBuild.getBuilder(name) as WrappedBuilder<[]>).builder();
    }
  }

  /**
   * 导航目标构建器
   * @returns 路由构建器
   */
  build() {
    Navigation(this.navPathStack) {
      MainPage()
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .navDestination(this.PagesMap)
  }
}
