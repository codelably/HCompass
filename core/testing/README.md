# 测试工具基座 (core/testing)

## 介绍

`@core/testing` 模块提供测试环境下的依赖注入容器管理工具。基于 `@core/di` 的子容器机制，实现：

- **测试隔离**：每个测试用例使用独立的子容器，避免测试之间相互影响
- **Mock 注入**：在子容器中注册 Mock 服务，覆盖父容器的真实实现
- **零侵入**：测试结束后恢复原始容器，不影响其他模块的服务注册

## 核心原理

利用 `ServiceContainer` 的父子容器链式查找机制：

1. `setup()` 基于当前全局容器创建子容器，子容器继承父容器的所有服务
2. `registerMock()` 在子容器中注册 Mock 服务，优先级高于父容器
3. `teardown()` 恢复原始全局容器，所有真实服务完好无损

```
全局容器 (父)                    测试子容器
+-----------------------+       +-----------------------+
| HttpClient (真实)     | <---- | AuthRepo (Mock)       |
| AuthRepo (真实)       |       |                       |
| UserRepo (真实)       |       |                       |
+-----------------------+       +-----------------------+

resolve(AuthRepo)  -> 子容器命中 Mock
resolve(HttpClient) -> 子容器未命中，回退到父容器返回真实服务
```

## 快速开始

### 1. 添加依赖

在功能包的 `oh-package.json5` 中添加：

```json5
{
  "dependencies": {
    "@core/testing": "file:../../core/testing"
  }
}
```

### 2. 基础用法

```typescript
import { describe, beforeEach, afterEach, it, expect } from "@ohos/hypium";
import { TestContainerHelper } from "@core/testing";
import { AUTH_REPOSITORY_KEY, IAuthRepository } from "@shared/contracts";

class MockAuthRepository implements IAuthRepository {
  async loginByPassword(params: PasswordLoginRequest): Promise<NetworkResult<Auth>> {
    return new NetworkResult<Auth>({ code: 200, data: new Auth() });
  }
}

describe("LoginViewModel", () => {
  const helper = new TestContainerHelper();
  const mockAuth = new MockAuthRepository();

  beforeEach(() => {
    helper.setup();
    helper.registerMock<IAuthRepository>(AUTH_REPOSITORY_KEY, mockAuth);
  });

  afterEach(() => {
    helper.teardown();
  });

  it("登录成功应更新状态", 0, async () => {
    const vm = new LoginViewModel();
    await vm.login();
    expect(vm.isLoginSuccess).assertTrue();
  });
});
```

## API 参考

### TestContainerHelper

| 方法 | 说明 |
|------|------|
| `setup()` | 保存当前全局容器，创建子容器并替换全局容器。重复调用未 teardown 时抛出异常 |
| `registerMock<T>(key, mock)` | 注册 Mock 服务到测试子容器。未调用 setup 时抛出异常 |
| `teardown()` | 恢复原始全局容器，清理测试状态 |

### 参数说明

| 参数 | 类型 | 说明 |
|------|------|------|
| `key` | `ServiceKey` | 服务标识符（string 或 symbol），与 `@core/di` 注册时使用的 key 一致 |
| `mock` | `T` | Mock 服务实例，需实现对应的服务接口 |

## 使用场景

### ViewModel 单元测试

Mock Repository 层，测试 ViewModel 的状态管理逻辑：

```typescript
describe("UserViewModel", () => {
  const helper = new TestContainerHelper();

  beforeEach(() => {
    helper.setup();
    helper.registerMock<IUserRepository>(USER_REPOSITORY_KEY, new MockUserRepository());
  });

  afterEach(() => {
    helper.teardown();
  });

  it("加载用户列表", 0, async () => {
    const vm = new UserViewModel();
    await vm.loadUsers();
    expect(vm.users.length).assertEqual(3);
  });
});
```

### Repository 集成测试

Mock DataSource 层，测试 Repository 的数据转换逻辑：

```typescript
describe("AuthRepositoryImpl", () => {
  const helper = new TestContainerHelper();

  beforeEach(() => {
    helper.setup();
    // Mock HttpClient，避免真实网络请求
    helper.registerMock<AxiosHttpClient>(CoreServiceKeys.HttpClient, new MockHttpClient());
  });

  afterEach(() => {
    helper.teardown();
  });

  it("登录失败应返回错误码", 0, async () => {
    const repo = new AuthRepositoryImpl();
    const result = await repo.loginByPassword(invalidParams);
    expect(result.isSuccess()).assertFalse();
  });
});
```

### 多个 Mock 服务组合

```typescript
beforeEach(() => {
  helper.setup();
  helper.registerMock<IAuthRepository>(AUTH_REPOSITORY_KEY, mockAuth);
  helper.registerMock<IUserRepository>(USER_REPOSITORY_KEY, mockUser);
  helper.registerMock<AxiosHttpClient>(CoreServiceKeys.HttpClient, mockHttp);
});
```

## 最佳实践

### 1. 始终配对使用 setup/teardown

```typescript
// beforeEach 中 setup，afterEach 中 teardown，确保每个用例隔离
beforeEach(() => helper.setup());
afterEach(() => helper.teardown());
```

### 2. Mock 类实现完整接口

```typescript
// 推荐：实现接口，编译期检查方法签名
class MockAuthRepository implements IAuthRepository {
  async loginByPassword(params: PasswordLoginRequest): Promise<NetworkResult<Auth>> {
    return new NetworkResult<Auth>({ code: 200, data: new Auth() });
  }
}

// 避免：遗漏接口方法，运行时才暴露问题
```

### 3. Mock 数据集中管理

建议在功能包的 `src/test/mock/` 目录下统一管理 Mock 类和测试数据：

```
packages/auth/
└── src/test/
    └── mock/
        ├── MockAuthRepository.ets
        └── MockAuthData.ets
```

## 注意事项

1. **必须先 setup 再 registerMock**：未初始化时调用 registerMock 会抛出异常
2. **禁止重复 setup**：连续调用两次 setup 而未 teardown 会抛出异常，防止丢失原始容器引用
3. **子容器不影响父容器**：Mock 服务仅存在于子容器中，teardown 后所有真实服务恢复正常

## 依赖关系

- `@core/di`：依赖注入容器，提供 Container、ServiceKey 等核心类型

## 文件结构

```
core/testing/
├── Index.ets                    # 模块导出
├── oh-package.json5             # 包配置
├── hvigorfile.ts                # 构建配置
└── src/main/
    ├── module.json5             # 模块配置
    └── ets/
        └── TestContainerHelper.ets  # 测试容器辅助类
```
