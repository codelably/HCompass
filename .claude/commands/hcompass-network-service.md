---
name: hcompass-network-service
description: "在 HCompass 框架中实现标准化网络服务。包括 DataSource 数据源分层（网络/本地）、Service 实现、NetworkResult 统一返回类型。触发场景：功能包需要进行 HTTP 网络请求时。"
---

# 实现网络服务

## 服务分层结构

```
packages/<name>/src/main/ets/services/
├── <Name>ServiceImpl.ets             # 服务实现（实现 shared/contracts 中的接口）
└── datasource/
    ├── <Name>NetworkDataSource.ets   # 网络数据源
    └── <Name>LocalDataSource.ets     # 本地缓存数据源（按需）
```

## 第一步：定义接口契约（若未完成）

先在 `shared/contracts` 中定义接口，参考 `/hcompass-contract-define`。

## 第二步：实现网络数据源

`datasource/<Name>NetworkDataSource.ets`：
```typescript
/**
 * @file <Name>网络数据源
 * @author JunBin.Yang
 */
import { HttpClient, NetworkResult } from "@core/network";
import { getContainer } from "@core/di";
import { HTTP_CLIENT_KEY } from "@core/network";
import { <Name>Data } from "@shared/contracts";

export class <Name>NetworkDataSource {
  private httpClient: HttpClient;

  constructor() {
    this.httpClient = getContainer().resolve<HttpClient>(HTTP_CLIENT_KEY);
  }

  /**
   * 获取<Name>数据
   * @param id 资源ID
   * @returns 网络请求结果
   */
  async getData(id: string): Promise<NetworkResult<<Name>Data>> {
    return this.httpClient.get<<Name>Data>(`/api/<name>/${id}`);
  }

  /**
   * 获取<Name>列表
   * @param page 页码（从1开始）
   * @param pageSize 每页条数
   */
  async getList(page: number, pageSize: number): Promise<NetworkResult<<Name>Data[]>> {
    return this.httpClient.get<<Name>Data[]>("/api/<name>/list", {
      params: { page, pageSize }
    });
  }

  /**
   * 提交数据
   * @param data 提交内容
   */
  async submitData(data: Partial<<Name>Data>): Promise<NetworkResult<void>> {
    return this.httpClient.post<void>("/api/<name>", data);
  }
}
```

## 第三步：实现 Service

`<Name>ServiceImpl.ets`：
```typescript
/**
 * @file <Name>服务实现
 * @author JunBin.Yang
 */
import { NetworkResult } from "@core/network";
import { I<Name>Service, <Name>Data } from "@shared/contracts";
import { <Name>NetworkDataSource } from "./datasource/<Name>NetworkDataSource";

export class <Name>ServiceImpl implements I<Name>Service {
  private networkDataSource: <Name>NetworkDataSource;

  constructor() {
    this.networkDataSource = new <Name>NetworkDataSource();
  }

  async getData(id: string): Promise<NetworkResult<<Name>Data>> {
    return this.networkDataSource.getData(id);
  }

  async getList(page: number, pageSize: number): Promise<NetworkResult<<Name>Data[]>> {
    return this.networkDataSource.getList(page, pageSize);
  }
}
```

## 第四步：在 ViewModel 中使用

```typescript
// BaseNetWorkViewModel 自动处理三态（加载/成功/错误）
@ObservedV2
export class <Name>ViewModel extends BaseNetWorkViewModel<<Name>Data> {
  private <name>Service: I<Name>Service;

  constructor() {
    super();
    this.<name>Service = getContainer().resolve<I<Name>Service>(<NAME>_SVC_KEY);
  }

  protected requestRepository(): Promise<NetworkResult<<Name>Data>> {
    return this.<name>Service.getData(this.id);
  }
}
```

## NetworkResult 错误处理

手动处理 NetworkResult 时：
```typescript
const result = await this.<name>Service.getData(id);
if (result.success && result.data) {
  this.data = result.data;
} else {
  // result.message 含错误信息
  this.errorMsg = result.message ?? "请求失败";
}
```

## 在 Module 中注册 Service

```typescript
// <Name>Module.registerServices 中：
registerServices(container: Container): void {
  container.register<I<Name>Service>(
    <NAME>_SVC_KEY,
    () => new <Name>ServiceImpl()
  );
}
```
