# 基础层 (core/base)

## 介绍

`@core/base` 模块提供应用的基础类和状态管理，包括：

- **ViewModel 基类**：统一的 ViewModel 抽象
- **网络请求 ViewModel**：自动化网络请求处理
- **列表 ViewModel**：分页列表数据管理
- **UI 状态管理**：标准化的 UI 状态

## 核心类

### BaseViewModel

所有 ViewModel 的基类，提供生命周期管理。

```typescript
@ObservedV2
export abstract class BaseViewModel {
  /**
   * 页面出现时的生命周期回调
   */
  aboutToAppear(): void {}

  /**
   * 页面即将消失时的生命周期回调
   */
  aboutToDisappear(): void {}
}
```

### BaseNetWorkViewModel

网络请求 ViewModel 基类，自动处理 loading、error、success 状态。

```typescript
@ObservedV2
export abstract class BaseNetWorkViewModel<T> extends BaseViewModel {
  @Trace uiState: BaseNetWorkUiState = BaseNetWorkUiState.LOADING;
  @Trace data: T | null = null;

  // 子类实现此方法
  protected abstract requestRepository(): Promise<NetworkResult<T>>;

  // 自动执行请求
  executeRequest(): void;

  // 重试请求
  retryRequest(): void;
}
```

### BaseNetWorkListViewModel

分页列表 ViewModel 基类，支持下拉刷新和上拉加载。

```typescript
@ObservedV2
export abstract class BaseNetWorkListViewModel<T> extends BaseViewModel {
  @Trace uiState: BaseNetWorkUiState = BaseNetWorkUiState.LOADING;
  @Trace dataList: T[] = [];
  @Trace hasMore: boolean = true;

  // 子类实现此方法
  protected abstract requestRepository(page: number, pageSize: number):
    Promise<NetworkResult<NetworkPageData<T>>>;

  // 刷新列表
  refreshList(): void;

  // 加载更多
  loadMore(): void;
}
```

## 快速开始

### 1. 简单数据请求

```typescript
import { BaseNetWorkViewModel } from "@core/base";
import { NetworkResult } from "@core/network";

@ObservedV2
export class UserViewModel extends BaseNetWorkViewModel<User> {
  private repository: IUserRepository = new UserRepositoryImpl();

  protected requestRepository(): Promise<NetworkResult<User>> {
    return this.repository.getUserInfo("123");
  }
}
```

### 2. 分页列表

```typescript
import { BaseNetWorkListViewModel } from "@core/base";
import { NetworkResult, NetworkPageData } from "@core/network";

@ObservedV2
export class GoodsListViewModel extends BaseNetWorkListViewModel<Goods> {
  private repository: IGoodsRepository = new GoodsRepositoryImpl();

  protected requestRepository(page: number, pageSize: number):
    Promise<NetworkResult<NetworkPageData<Goods>>> {
    return this.repository.getGoodsPage({ page, pageSize });
  }
}
```

### 3. 在页面中使用

```typescript
@Entry
@Component
struct UserPage {
  @Local viewModel: UserViewModel = new UserViewModel();

  build() {
    Column() {
      if (this.viewModel.uiState === BaseNetWorkUiState.LOADING) {
        LoadingView()
      } else if (this.viewModel.uiState === BaseNetWorkUiState.ERROR) {
        ErrorView({ onRetry: () => this.viewModel.retryRequest() })
      } else if (this.viewModel.uiState === BaseNetWorkUiState.SUCCESS) {
        UserInfoView({ user: this.viewModel.data })
      }
    }
  }
}
```

## UI 状态

```typescript
export enum BaseNetWorkUiState {
  LOADING = 'loading',   // 加载中
  SUCCESS = 'success',   // 成功
  ERROR = 'error',       // 错误
  EMPTY = 'empty'        // 空数据
}
```

## 文件结构

```
core/base/
├── Index.ets                         # 模块导出
├── README.md                         # 本文档
└── src/main/ets/
    ├── viewmodel/
    │   ├── BaseViewModel.ets         # ViewModel 基类
    │   ├── BaseNetWorkViewModel.ets  # 网络请求基类
    │   └── BaseNetWorkListViewModel.ets  # 列表基类
    └── state/
        └── BaseNetWorkUiState.ets    # UI 状态枚举
```
