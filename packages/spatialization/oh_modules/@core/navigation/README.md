# 路由守卫系统 (core/navigation)

## 介绍

路由守卫系统为 `@core/navigation` 模块新增的功能，提供：

- **路由拦截**：在导航前进行校验和拦截
- **守卫链**：支持多个守卫按优先级执行
- **灵活配置**：支持登录守卫、权限守卫、条件守卫等

## 核心概念

### 路由守卫 (RouteGuard)

路由守卫是一个实现了 `RouteGuard` 接口的对象，用于在导航前进行拦截：

```typescript
interface RouteGuard {
  name?: string;           // 守卫名称
  priority?: number;       // 优先级（越小越先执行）
  canActivate(context: RouteContext): Promise<boolean | GuardResult> | boolean | GuardResult;
  onReject?(context: RouteContext, result: GuardResult): void;
}
```

### 路由上下文 (RouteContext)

```typescript
interface RouteContext {
  targetRoute: string;     // 目标路由
  params?: unknown;        // 导航参数
  fromRoute?: string;      // 来源路由
  extra?: Record<string, unknown>;  // 额外数据
}
```

### 守卫结果 (GuardResult)

```typescript
interface GuardResult {
  canActivate: boolean;    // 是否允许导航
  redirectTo?: string;     // 重定向路由
  redirectParams?: unknown; // 重定向参数
  reason?: string;         // 拒绝原因
}
```

## 快速开始

### 1. 使用导航服务

```typescript
import { NavigationService } from '@core/navigation';

// 创建导航服务
const navService = new NavigationService(navPathStack);

// 导航（会经过守卫检查）
await navService.navigateTo('user/profile', { userId: '123' });

// 跳过守卫检查
await navService.navigateTo('public/page', undefined, { skipGuards: true });
```

### 2. 注册登录守卫

```typescript
import { createAuthGuard } from '@core/navigation';

const authGuard = createAuthGuard({
  name: 'LoginGuard',
  protectedRoutes: [
    'user/profile',
    'order/list',
    'settings'
  ],
  loginRoute: 'auth/login',
  isAuthenticated: () => {
    return userState.isLoggedIn();
  },
  onAuthRequired: (context) => {
    console.log(`需要登录才能访问: ${context.targetRoute}`);
  }
});

navService.registerGuard(authGuard);
```

### 3. 注册权限守卫

```typescript
import { createPermissionGuard } from '@core/navigation';

const permissionGuard = createPermissionGuard({
  name: 'PermissionGuard',
  routePermissions: new Map([
    ['admin/users', ['admin', 'user:manage']],
    ['admin/settings', ['admin']],
    ['report/view', ['report:view']]
  ]),
  getUserPermissions: () => {
    return userState.getPermissions();
  },
  forbiddenRoute: 'error/403',
  onForbidden: (context, required) => {
    console.log(`缺少权限: ${required.join(', ')}`);
  }
});

navService.registerGuard(permissionGuard);
```

## API 参考

### EnhancedNavigationService

| 方法 | 说明 |
|------|------|
| `registerGuard(guard)` | 注册路由守卫 |
| `unregisterGuard(guard)` | 注销路由守卫 |
| `unregisterGuardByName(name)` | 通过名称注销守卫 |
| `navigateTo(name, params?, options?)` | 路由跳转 |
| `navigateBack(animated?)` | 返回上一页 |
| `navigateBackWithResult(result, animated?)` | 携带结果返回 |
| `popTo(name, inclusive?)` | 返回到指定路由 |
| `navigateToWithResult(name, params?, onPop?, options?)` | 跳转并监听返回 |
| `navigateToForResult<T>(name, params?, options?)` | 跳转并获取返回结果 |
| `getRouteParams<T>(name)` | 获取路由参数 |
| `getCurrentRoute()` | 获取当前路由 |
| `getGuardManager()` | 获取守卫管理器 |

### NavigateOptions

```typescript
interface NavigateOptions {
  skipGuards?: boolean;  // 是否跳过守卫检查
  animated?: boolean;    // 是否需要动画
}
```

### 常用守卫工厂函数

| 函数 | 说明 |
|------|------|
| `createAuthGuard(config)` | 创建登录守卫 |
| `createPermissionGuard(config)` | 创建权限守卫 |
| `createConditionalGuard(config)` | 创建条件守卫 |
| `createLogGuard(name?)` | 创建日志守卫 |
| `createGuard(config)` | 通用守卫创建函数 |

## 自定义守卫

### 使用 createGuard 快速创建

```typescript
import { createGuard } from '@core/navigation';

const quickGuard = createGuard({
  name: 'QuickGuard',
  priority: 40,
  routes: ['protected/page1', 'protected/page2'],
  check: () => isUserVerified(),
  redirectTo: 'verify/phone',
  onFail: (context) => {
    showToast('请先完成手机验证');
  }
});
```

## 守卫执行顺序

守卫按 `priority` 从小到大执行：

```typescript
// priority: 1 - 最先执行
const logGuard = createLogGuard();

// priority: 10 - 其次执行
const authGuard = createAuthGuard({ ... });

// priority: 20 - 最后执行
const permissionGuard = createPermissionGuard({ ... });
```

如果任一守卫返回 `canActivate: false`，后续守卫不再执行。

## 与 DI 容器集成

```typescript
import { register, resolve, CoreServiceKeys } from '@core/di';
import { NavigationService, createAuthGuard } from '@core/navigation';

// 注册导航服务
register(CoreServiceKeys.NavigationService, () => {
  const navService = new NavigationService(navPathStack);

  // 注册守卫
  navService.registerGuard(createAuthGuard({
    protectedRoutes: ['user/profile'],
    loginRoute: 'auth/login',
    isAuthenticated: () => resolve('UserState').isLoggedIn()
  }));

  return navService;
});

// 使用
const navService = resolve<NavigationService>(CoreServiceKeys.NavigationService);
await navService.navigateTo('user/profile');
```

## 最佳实践

### 1. 守卫职责单一

```typescript
// 好：每个守卫只做一件事
const authGuard = createAuthGuard({ ... });
const permissionGuard = createPermissionGuard({ ... });
const featureGuard = createConditionalGuard({ ... });

// 避免：一个守卫做太多事情
```

### 2. 合理设置优先级

```typescript
// 推荐的优先级分配
// 1-9: 日志、监控类守卫
// 10-19: 认证守卫
// 20-29: 权限守卫
// 30-49: 业务条件守卫
// 50+: 其他守卫
```

### 3. 提供有意义的拒绝原因

```typescript
return {
  canActivate: false,
  redirectTo: 'error/403',
  reason: `缺少权限: ${missingPermissions.join(', ')}`  // 便于调试
};
```

## 文件结构

```
core/navigation/src/main/ets/
├── RouteGuard.ets              # 守卫接口定义
├── GuardManager.ets            # 守卫管理器
├── NavigationService.ets       # 导航服务
└── CommonGuards.ets            # 常用守卫
```
