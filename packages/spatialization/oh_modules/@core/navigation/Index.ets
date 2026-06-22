/**
 * @file navigation 模块统一导出
 * @author Joker.X JunBin.Yang
 */

export { RouteBuild } from "./src/main/ets/RouteBuild";

// 路由守卫相关导出
export type { RouteGuard, RouteContext, GuardResult, GuardConfig } from "./src/main/ets/RouteGuard";

export { GuardManager, createGuard } from "./src/main/ets/GuardManager";

export { NavigationService, NAV_PATH_STACK_KEY } from "./src/main/ets/NavigationService";
export type { NavigateOptions } from "./src/main/ets/NavigationService";

// 常用守卫导出
export { createAuthGuard,createPermissionGuard,createConditionalGuard,createLogGuard } from "./src/main/ets/CommonGuards";
export type { AuthGuardConfig, PermissionGuardConfig, ConditionalGuardConfig } from "./src/main/ets/CommonGuards";