# 依赖注入容器 (core/di)

## 介绍

`@core/di` 模块提供轻量级的依赖注入（DI）容器，用于管理服务的创建和生命周期。通过 DI 容器，可以实现：

- **解耦**：业务代码不直接依赖具体实现，而是依赖抽象接口
- **可测试**：轻松替换实现进行单元测试
- **可维护**：集中管理服务的创建和配置

## 核心概念

### 服务标识符 (ServiceKey)

服务标识符用于唯一标识一个服务，支持两种类型：

- `string`：字符串标识符，适合跨模块使用
- `symbol`：Symbol 标识符，确保唯一性，适合框架内部使用

### 服务工厂 (ServiceFactory)

服务工厂是一个无参函数，返回服务实例：

```typescript
type ServiceFactory<T> = () => T;
```

### 单例模式

默认情况下，服务以单例模式注册。单例服务在首次解析时创建，后续解析返回同一实例。

## 快速开始

### 1. 导入模块

```typescript
import { register, resolve, has, CoreServiceKeys } from '@core/di';
```

### 2. 注册服务

```typescript
// 注册单例服务（默认）
register<UserService>('UserService', () => new UserServiceImpl());

// 注册非单例服务
register<Logger>('Logger', () => new ConsoleLogger(), { singleton: false });

// 使用 Symbol 作为标识符
const USER_SERVICE = Symbol('UserService');
register<UserService>(USER_SERVICE, () => new UserServiceImpl());
```

### 3. 解析服务

```typescript
// 解析服务（服务不存在时抛出异常）
const userService = resolve<UserService>('UserService');

// 尝试解析服务（服务不存在时返回 undefined）
const logger = tryResolve<Logger>('Logger');
if (logger) {
  logger.log('Hello');
}
```

### 4. 检查服务

```typescript
if (has('UserService')) {
  // 服务已注册
}
```

## API 参考

### 全局函数

| 函数 | 说明 |
|------|------|
| `register<T>(key, factory, options?)` | 注册服务到全局容器 |
| `resolve<T>(key)` | 解析服务，不存在时抛出异常 |
| `tryResolve<T>(key)` | 尝试解析服务，不存在时返回 undefined |
| `has(key)` | 检查服务是否已注册 |
| `getContainer()` | 获取全局容器实例 |
| `setContainer(container)` | 设置全局容器实例 |
| `resetContainer()` | 重置全局容器 |

### Container 接口

```typescript
interface Container {
  register<T>(key: ServiceKey, factory: ServiceFactory<T>, options?: ServiceOptions): void;
  resolve<T>(key: ServiceKey): T;
  tryResolve<T>(key: ServiceKey): T | undefined;
  has(key: ServiceKey): boolean;
  unregister(key: ServiceKey): boolean;
  clear(): void;
  createChild(): Container;
}
```

### ServiceOptions

```typescript
interface ServiceOptions {
  singleton?: boolean;  // 是否为单例，默认 true
}
```

## 高级用法

### 子容器

子容器继承父容器的服务，但可以覆盖或新增服务：

```typescript
import { getContainer } from '@core/di';

const parentContainer = getContainer();
const childContainer = parentContainer.createChild();

// 子容器可以覆盖父容器的服务
childContainer.register<Logger>('Logger', () => new MockLogger());

// 子容器可以访问父容器的服务
const userService = childContainer.resolve<UserService>('UserService');
```

### 依赖其他服务

服务工厂中可以解析其他服务：

```typescript
import { register, resolve } from '@core/di';

// 注册基础服务
register<HttpClient>('HttpClient', () => new HttpClient());

// 注册依赖其他服务的服务
register<UserRepository>('UserRepository', () => {
  const httpClient = resolve<HttpClient>('HttpClient');
  return new UserRepositoryImpl(httpClient);
});
```

### 框架服务键

框架预定义了一些服务键：

```typescript
import { CoreServiceKeys } from '@core/di';

// 可用的服务键
CoreServiceKeys.HttpClient       // HTTP 客户端
CoreServiceKeys.NavigationService // 导航服务
CoreServiceKeys.ConfigManager    // 配置管理
```

## 最佳实践

### 1. 在应用启动时注册服务

```typescript
// EntryAbility.ets
import { register } from '@core/di';

onCreate(): void {
  this.registerServices();
}

private registerServices(): void {
  register<HttpClient>(CoreServiceKeys.HttpClient, () => new HttpClient());
  register<UserService>('UserService', () => new UserServiceImpl());
}
```

### 2. 在 ViewModel 中使用服务

```typescript
import { resolve } from '@core/di';

@ObservedV2
export default class UserViewModel extends BaseViewModel {
  private userService: UserService;

  constructor() {
    super();
    this.userService = resolve<UserService>('UserService');
  }

  async loadUser(): Promise<void> {
    const user = await this.userService.getCurrentUser();
    // ...
  }
}
```

### 3. 定义服务接口

```typescript
// 定义接口
interface UserService {
  getCurrentUser(): Promise<User>;
  updateUser(user: User): Promise<void>;
}

// 实现接口
class UserServiceImpl implements UserService {
  async getCurrentUser(): Promise<User> {
    // 实现
  }

  async updateUser(user: User): Promise<void> {
    // 实现
  }
}

// 注册实现
register<UserService>('UserService', () => new UserServiceImpl());
```

### 4. 单元测试中替换服务

```typescript
import { setContainer, ServiceContainer } from '@core/di';

describe('UserViewModel', () => {
  beforeEach(() => {
    const testContainer = new ServiceContainer();
    testContainer.register<UserService>('UserService', () => new MockUserService());
    setContainer(testContainer);
  });

  it('should load user', async () => {
    const viewModel = new UserViewModel();
    await viewModel.loadUser();
    // 断言
  });
});
```

## 注意事项

1. **避免循环依赖**：服务 A 依赖服务 B，服务 B 又依赖服务 A 会导致问题
2. **注册顺序**：确保被依赖的服务先注册
3. **单例生命周期**：单例服务在应用生命周期内只创建一次
4. **类型安全**：使用泛型确保类型安全

## 文件结构

```
core/di/
├── Index.ets                    # 模块导出
├── oh-package.json5             # 包配置
├── hvigorfile.ts                # 构建配置
├── BuildProfile.ets             # 构建配置
└── src/main/
    ├── module.json5             # 模块配置
    └── ets/
        ├── Container.ets        # 容器接口
        ├── ServiceContainer.ets # 容器实现
        ├── ServiceProvider.ets  # 类型定义
        ├── GlobalContainer.ets  # 全局容器
        └── ServiceKeys.ets      # 服务键定义
```
