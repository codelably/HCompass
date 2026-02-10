/**
 * @file Demo 模块导航图
 * @author Joker.X
 */

import { DemoRoutes } from "@shared/contracts";
import { NetworkDemoNav } from "./NetworkDemoNav";
import { NetworkListDemoNav } from "./NetworkListDemoNav";
import { DatabaseNav } from "./DatabaseNav";
import { LocalStorageNav } from "./LocalStorageNav";
import { StateManagementNav } from "./StateManagementNav";
import { NetworkRequestNav } from "./NetworkRequestNav";
import { NavigationWithArgsNav } from "./NavigationWithArgsNav";
import { NavigationResultNav } from "./NavigationResultNav";
import { SafeAreaDemoNav } from "./SafeAreaDemoNav";
import { ScreenAdaptDemoNav } from "./ScreenAdaptDemoNav";
import { RouteRegistry } from "@core/module";

export class RouteGraph {
  /**
   * 注册 Demo 模块导航路由
   * @returns {void} 无返回值
   */
  static register(registry: RouteRegistry): void {
    registry.register(DemoRoutes.NetworkDemo, wrapBuilder(NetworkDemoNav));
    registry.register(DemoRoutes.NetworkListDemo, wrapBuilder(NetworkListDemoNav));
    registry.register(DemoRoutes.Database, wrapBuilder(DatabaseNav));
    registry.register(DemoRoutes.LocalStorage, wrapBuilder(LocalStorageNav));
    registry.register(DemoRoutes.StateManagement, wrapBuilder(StateManagementNav));
    registry.register(DemoRoutes.NetworkRequest, wrapBuilder(NetworkRequestNav));
    registry.register(DemoRoutes.NavigationWithArgs, wrapBuilder(NavigationWithArgsNav));
    registry.register(DemoRoutes.NavigationResult, wrapBuilder(NavigationResultNav));
    registry.register(DemoRoutes.SafeAreaDemo, wrapBuilder(SafeAreaDemoNav));
    registry.register(DemoRoutes.ScreenAdaptDemo, wrapBuilder(ScreenAdaptDemoNav));
  }
}
