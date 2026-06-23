---
name: hcompass-navigation-register
description: "在 HCompass 框架中注册路由和配置路由守卫。包括 WrappedBuilder 构建器创建、Module.registerRoutes 注册、RouteGuard 守卫实现。触发场景：新建页面需要路由跳转，或需要拦截特定路由时。"
---

# 注册路由与守卫

## 框架路由约定

- 禁用 `@ohos.router`，统一使用 `Navigation + NavPathStack + NavigationService`
- 路由路径格式：`模块名/页面名`（小写，如 `user/profile`）
- 每个路由页必须是 `NavDestination` 组件

## 第一步：创建页面（NavDestination）

`packages/<name>/src/main/ets/view/<Name>Page.ets`：
```typescript
/**
 * @file <Name>页面
 * @author JunBin.Yang
 */
import { AppHdsNavDestination } from "@core/components";  // 或 AppNavDestination

@ComponentV2
struct <Name>PageContent {
  @Param params: Record<string, Object> = {};
  @Local viewModel: <Name>ViewModel = new <Name>ViewModel();

  build() {
    Column() {
      // 页面内容
    }
  }
}

@Builder
export function <name>PageBuilder(name: string, param: object) {
  AppNavDestination({ title: "<页面标题>" }) {
    <Name>PageContent({ params: param as Record<string, Object> })
  }
}
```

## 第二步：创建路由构建器（WrappedBuilder）

`packages/<name>/src/main/ets/navigation/<Name>PageNav.ets`：
```typescript
/**
 * @file <Name>页面路由构建器
 * @author JunBin.Yang
 */
import { WrappedBuilder, wrapBuilder } from "@kit.ArkUI";
import { <name>PageBuilder } from "../view/<Name>Page";

/** 路由构建器包装，注册到全局路由表 */
export const <name>PageNavBuilderWrapper: WrappedBuilder<[string, object]> =
  wrapBuilder(<name>PageBuilder);
```

## 第三步：在 Module 中注册路由

`packages/<name>/src/main/ets/<Name>Module.ets`：
```typescript
import { <Name>Routes } from "@shared/contracts";
import { <name>PageNavBuilderWrapper } from "./navigation/<Name>PageNav";

// 在 registerRoutes 方法中：
registerRoutes(registry: RouteRegistry): void {
  registry.register(<Name>Routes.Main, <name>PageNavBuilderWrapper);
  registry.register(<Name>Routes.Detail, <name>DetailPageNavBuilderWrapper);
}
```

## 路由跳转

在 ViewModel 中注入 `NavigationService`：
```typescript
import { NavigationService, getNavigationService } from "@core/navigation";
import { <Name>Routes } from "@shared/contracts";

// 普通跳转
getNavigationService().navigateTo(<Name>Routes.Main);

// 携带参数跳转
getNavigationService().navigateTo(<Name>Routes.Detail, { id: "123" });

// 跳转并等待返回值
const result = await getNavigationService().navigateForResult(<Name>Routes.Edit, { id: "123" });

// 返回
getNavigationService().goBack();

// 返回并携带数据
getNavigationService().goBackWithResult({ updated: true });
```

## 第四步：配置路由守卫（按需）

需要保护路由（如登录检查）时，在 Module 中注册守卫：

`packages/<name>/src/main/ets/guards/<Name>Guard.ets`：
```typescript
/**
 * @file <Name>路由守卫
 * @author JunBin.Yang
 */
import { RouteGuard, RouteContext, GuardResult } from "@core/navigation";

export class <Name>Guard implements RouteGuard {
  readonly name: string = "<Name>Guard";
  readonly priority: number = 100;  // 数字越大优先级越高

  canActivate(context: RouteContext): boolean | Promise<boolean> {
    // 返回 true 允许导航，false 拦截
    // 示例：检查登录状态
    return isLoggedIn();
  }

  onReject(context: RouteContext, result: GuardResult): void {
    // 被拦截后的处理，如跳转到登录页
    getNavigationService().navigateTo(AuthRoutes.Login);
  }
}
```

在 `<Name>Module.registerGuards` 中注册：
```typescript
registerGuards(navigationService: NavigationService): void {
  navigationService.addGuard(new <Name>Guard());
}
```

## 常见问题

| 问题 | 原因 | 修复 |
|-----|------|------|
| 跳转后空白页 | 路由未注册或 Builder 名与路径不匹配 | 检查 registerRoutes 中的路径与 navigateTo 参数一致 |
| 路由拦截不生效 | 守卫 priority 冲突或未注册 | 确认 registerGuards 已调用，检查 priority 值 |
| 参数取不到 | NavDestination 的 param 类型不对 | 确认 Builder 第二个参数类型为 `object`，接收时转换类型 |
