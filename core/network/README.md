# 网络抽象层 (core/network)

## 介绍

`@core/network` 模块提供网络请求的抽象层，支持：

- **可配置的响应解析**：适配不同后端的响应格式
- **拦截器机制**：支持请求和响应拦截
- **链式请求助手**：简化请求处理流程
- **统一的响应封装**：标准化的响应结果
- **自动配置注入**：从 DI 容器自动获取配置

## 核心概念

### 响应解析器 (ResponseParser)

响应解析器用于解析不同格式的后端响应。通过配置解析器，可以适配任意后端的响应格式。

```typescript
interface ResponseParser<T> {
  isSuccess(response: unknown): boolean;
  getData(response: unknown): T | null;
  getMessage(response: unknown): string | null;
  getCode(response: unknown): number;
}
```

### 网络配置 (NetworkConfig)

```typescript
interface NetworkConfig {
  baseUrl: string;      // 基础 URL
  timeout: number;      // 超时时间（毫秒）
  responseParser?: ResponseParserConfig;  // 响应解析配置
  headers?: Record<string, string>;  // 默认请求头
  enableLog?: boolean;  // 是否启用日志
}

interface ResponseParserConfig {
  successCode: number;   // 成功状态码
  dataField: string;     // 数据字段名
  messageField: string;  // 消息字段名
  codeField: string;     // 状态码字段名
}
```

## 快速开始

### 1. 配置网络模块

```typescript
import { getContainer, CoreServiceKeys } from '@core/di';
import { AxiosHttpClient, NetworkConfig } from '@core/network';

// 在 EntryAbility 中配置
const NetConf: NetworkConfig = {
  baseUrl: "https://api.example.com/",
  timeout: 10000,
  responseParser: {
    successCode: 1000,  // 根据后端定义
    dataField: 'data',
    messageField: 'message',
    codeField: 'code'
  },
  headers: {
    'Content-Type': 'application/json'
  },
  enableLog: true
};

// 注册到 DI 容器
const container = getContainer();
container.register<NetworkConfig>(CoreServiceKeys.ConfigManager, () => NetConf);

// 创建并注册 HTTP 客户端
const httpClient = new AxiosHttpClient(NetConf);
container.register<AxiosHttpClient>(CoreServiceKeys.HttpClient, () => httpClient);
```

### 2. 在 DataSource 中使用

```typescript
import { CoreServiceKeys, getContainer } from "@core/di";
import { AxiosHttpClient, NetworkResult } from "@core/network";

export class UserNetworkDataSourceImpl {
  async getUserInfo(id: string): Promise<NetworkResult<User>> {
    const httpClient = getContainer().resolve<AxiosHttpClient>(CoreServiceKeys.HttpClient);
    const rawResponse = await httpClient.get<Unknown>("user/info", { params: { id } });
    return new NetworkResult<User>(rawResponse);
  }
}
```

### 3. 在 ViewModel 中使用 RequestHelper

**推荐方式：使用 `fromResult()`**

```typescript
import { RequestHelper } from "@core/network";

export class UserViewModel {
  loadUserInfo(): void {
    RequestHelper.fromResult<User>(this.repository.getUserInfo("123"))
      .start(() => this.isLoading = true)
      .toast(true)  // 自动显示错误提示
      .execute()
      .then((user: User) => {
        this.user = user;
      })
      .finally(() => this.isLoading = false);
  }
}
```

## API 参考

### AxiosHttpClient

| 方法 | 说明 |
|------|------|
| `get<T>(url, options?)` | GET 请求 |
| `post<T>(url, data?, options?)` | POST 请求 |
| `put<T>(url, data?, options?)` | PUT 请求 |
| `delete<T>(url, options?)` | DELETE 请求 |
| `addInterceptor(interceptor)` | 添加拦截器 |
| `removeInterceptor(interceptor)` | 移除拦截器 |
| `getConfig()` | 获取当前配置 |
| `updateConfig(config)` | 更新配置 |

### RequestOptions

```typescript
interface RequestOptions {
  headers?: Record<string, string>;  // 请求头
  timeout?: number;                   // 超时时间
  params?: Record<string, unknown>;   // URL 参数
}
```

### NetworkResult

```typescript
class NetworkResult<T> {
  readonly data: T | null;           // 响应数据
  readonly code: number;             // 状态码
  readonly message: string | null;   // 响应消息
  readonly isSuccess: boolean;       // 是否成功
  readonly rawResponse: unknown;     // 原始响应

  static success<T>(data: T, message?: string): NetworkResult<T>;
  static failure<T>(code: number, message: string): NetworkResult<T>;
  static error<T>(error: Error): NetworkResult<T>;
}
```

### RequestHelper

```typescript
class RequestHelper<T> {
  // 从原始响应创建（自动解析）
  static from<T>(promise: Promise<unknown>, parser?: ResponseParser<T>): RequestHelper<T>;

  // 从 NetworkResult 创建（推荐）
  static fromResult<T>(promise: Promise<NetworkResult<T>>): RequestHelper<T>;

  start(handler: () => void): RequestHelper<T>;
  loading(enable?: boolean): RequestHelper<T>;
  toast(enable?: boolean): RequestHelper<T>;
  onLoading(show: () => void, hide: () => void): RequestHelper<T>;
  onError(callback: (message: string) => void): RequestHelper<T>;

  execute(): Promise<T>;
  response(): Promise<NetworkResult<T>>;
}
```

## 拦截器

### 创建拦截器

```typescript
import { HttpInterceptor } from '@core/network';
import type { InternalAxiosRequestConfig, AxiosResponse, AxiosError } from '@ohos/axios';

// Token 拦截器
export class AuthInterceptor implements HttpInterceptor {
  name = 'AuthInterceptor';
  priority = 10;

  async onRequest(config: InternalAxiosRequestConfig): Promise<InternalAxiosRequestConfig> {
    const token = getUserState().getToken();
    if (token) {
      const headers = AxiosHeaders.from(config.headers);
      headers.set('Authorization', token);
      config.headers = headers;
    }
    return config;
  }

  onRequestError(error: AxiosError): Promise<never> {
    return Promise.reject(error);
  }
}
```

### 注册拦截器

```typescript
// 在 EntryAbility 中注册
const httpClient = new AxiosHttpClient(NetConf);
httpClient.addInterceptor(new LogInterceptor());
httpClient.addInterceptor(new AuthInterceptor());
```

## 架构模式

### 推荐的数据流

```
Server Response: {code: 1000, data: {...}, message: "success"}
  ↓
HttpClient 返回原始响应
  ↓
DataSource 创建 NetworkResult
  new NetworkResult<T>(rawResponse)
  ↓
Repository 返回 NetworkResult<T>
  ↓
ViewModel 使用 RequestHelper.fromResult()
  .start() .loading() .toast() .execute()
  ↓
得到解析后的数据 T
```

### 完整示例

**1. DataSource 层**
```typescript
export class AuthNetworkDataSourceImpl implements AuthNetworkDataSource {
  async loginByPassword(params: PasswordLoginRequest): Promise<NetworkResult<Auth>> {
    const httpClient = getContainer().resolve<AxiosHttpClient>(CoreServiceKeys.HttpClient);
    const rawResponse = await httpClient.post<Unknown>("user/login/password", params);
    return new NetworkResult<Auth>(rawResponse);
  }
}
```

**2. Repository 层**
```typescript
export class AuthRepositoryImpl implements IAuthRepository {
  async loginByPassword(params: PasswordLoginRequest): Promise<NetworkResult<Auth>> {
    return this.networkDataSource.loginByPassword(params);
  }
}
```

**3. ViewModel 层**
```typescript
export class LoginViewModel extends BaseViewModel {
  login(): void {
    RequestHelper.fromResult<Auth>(this.authRepository.loginByPassword(params))
      .start(() => this.isLoginLoading = true)
      .execute()
      .then((authData: Auth) => this.onLoginSuccess(authData))
      .finally(() => this.isLoginLoading = false);
  }
}
```

## 最佳实践

### 1. 统一配置管理

在 EntryAbility 中统一配置网络模块，所有 DataSource 自动获取配置。

### 2. 使用 NetworkResult

DataSource 层统一返回 `NetworkResult<T>`，保证类型安全。

### 3. 使用 RequestHelper.fromResult()

ViewModel 层使用 `fromResult()` 方法，享受链式 API 的便利。

### 4. 拦截器优先级

- LogInterceptor: priority = 1（最先执行）
- AuthInterceptor: priority = 10
- 其他业务拦截器: priority = 20+

## 文件结构

```
core/network/
├── Index.ets                         # 模块导出
├── README.md                         # 本文档
├── oh-package.json5                  # 包配置
└── src/main/ets/
    ├── NetworkConfig.ets             # 网络配置
    ├── ResponseParser.ets            # 响应解析器接口
    ├── DefaultResponseParser.ets     # 默认响应解析器
    ├── HttpClient.ets                # HTTP 客户端接口
    ├── AxiosHttpClient.ets           # Axios 实现
    ├── HttpInterceptor.ets           # 拦截器接口
    ├── NetworkResult.ets             # 响应结果封装
    ├── RequestHelper.ets             # 请求助手
    ├── NetworkPageData.ets           # 分页数据封装
    └── NetworkPageMeta.ets           # 分页元数据
```
