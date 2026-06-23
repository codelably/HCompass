---
name: hcompass-di-register
description: "HCompass DI 容器的服务注册、解析和生命周期管理。包括 register/resolve/tryResolve 用法、子容器创建、常见 DI 错误排查。触发场景：功能包注册服务或跨包解析服务时。"
---

# DI 容器使用指南

## 核心 API

```typescript
import { getContainer } from "@core/di";

const container = getContainer();  // 获取全局单例容器
```

## 注册服务

**在 Module.registerServices 中注册**（唯一正确位置）：

```typescript
import { Container } from "@core/di";
import { MY_SVC_KEY, IMyService } from "@shared/contracts";
import { MyServiceImpl } from "./services/MyServiceImpl";

registerServices(container: Container): void {
  // 工厂注册（每次 resolve 创建新实例）
  container.register<IMyService>(MY_SVC_KEY, () => new MyServiceImpl());

  // 单例注册（整个生命周期只有一个实例）
  const instance = new MyServiceImpl();
  container.register<IMyService>(MY_SVC_KEY, () => instance);
}
```

## 解析服务

### 在 ViewModel 构造函数中注入（推荐）

```typescript
import { getContainer } from "@core/di";
import { MY_SVC_KEY, IMyService } from "@shared/contracts";

@ObservedV2
export class MyViewModel extends BaseViewModel {
  private myService: IMyService;

  constructor() {
    super();
    // resolve：明确知道服务已注册时使用，未注册会抛出异常
    this.myService = getContainer().resolve<IMyService>(MY_SVC_KEY);
  }
}
```

### tryResolve：可选依赖

```typescript
// tryResolve：不确定服务是否注册时使用，未注册返回 undefined
const optionalService = getContainer().tryResolve<IOptionalService>(OPTIONAL_SVC_KEY);
if (optionalService) {
  optionalService.doSomething();
}
```

## 服务注销

```typescript
// 模块销毁时注销服务（在 Module.onDestroy 中）
onDestroy(): void {
  getContainer().unregister(MY_SVC_KEY);
}
```

## 子容器（按需使用）

子容器继承父容器所有服务，同时可覆盖注册：
```typescript
const childContainer = getContainer().createChild();
childContainer.register<IMyService>(MY_SVC_KEY, () => new MockServiceImpl());
// 子容器独立销毁，不影响父容器
```

## DI Key 命名规范

| 场景 | 命名格式 | 示例 |
|------|---------|------|
| 业务服务 | `<模块名>Service` | `"authService"` |
| 导航服务 | `<模块名>NavService` | `"userNavService"` |
| 仓储 | `<模块名>Repository` | `"userRepository"` |
| 网络客户端 | 固定 `httpClient` | `HTTP_CLIENT_KEY` |

## 常见错误排查

| 错误信息 | 原因 | 修复 |
|---------|------|------|
| `Service not found: xxx` | 服务未注册或注册顺序问题 | 确认 Module.registerServices 已执行，检查模块依赖顺序 |
| `Circular dependency detected` | 模块 A 依赖 B，B 又依赖 A | 重新设计，提取公共接口到 shared/contracts |
| resolve 返回了旧实例 | 工厂函数捕获了外部变量 | 确保工厂函数每次都 `new` 一个新实例 |

## 注意事项

- 禁止在 ViewModel 以外的地方（View/Page）直接调用 `getContainer().resolve()`
- 禁止在模块初始化完成前解析服务（不要在模块静态初始化代码中 resolve）
- 服务依赖应通过构造函数注入，不要在方法内懒加载解析
