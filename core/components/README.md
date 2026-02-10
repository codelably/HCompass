# Components Module

可复用 UI 组件模块，提供常用的业务组件，包括缺省页、加载状态、网络请求视图、下拉刷新等。

## 功能特性

### 缺省页组件

#### Empty - 通用缺省页

基础缺省页组件，支持自定义图片、描述和操作按钮。

```typescript
import { Empty } from '@core/components';

@Entry
@ComponentV2
struct MyPage {
  build() {
    Empty({
      imageRes: $r('app.media.empty'),
      description: '暂无数据',
      actionText: '刷新',
      onAction: () => {
        // 重新加载数据
      }
    });
  }
}
```

#### EmptyData - 无数据缺省页

预设的无数据缺省页，使用默认的空数据图标和文案。

```typescript
import { EmptyData } from '@core/components';

EmptyData({
  onAction: () => {
    // 刷新操作
  }
});
```

#### EmptyError - 错误缺省页

预设的错误缺省页，用于显示加载失败状态。

```typescript
import { EmptyError } from '@core/components';

EmptyError({
  onAction: () => {
    // 重试操作
  }
});
```

#### EmptyNetwork - 网络错误缺省页

预设的网络错误缺省页，用于显示网络异常状态。

```typescript
import { EmptyNetwork } from '@core/components';

EmptyNetwork({
  onAction: () => {
    // 重试操作
  }
});
```

### 加载组件

#### PageLoading - 页面加载

全屏加载指示器，用于页面级别的加载状态。

```typescript
import { PageLoading } from '@core/components';

PageLoading();
```

### 网络请求视图

#### BaseNetWorkView - 网络请求视图

自动处理网络请求的加载、成功、失败状态切换的容器组件。

```typescript
import { BaseNetWorkView } from '@core/components';
import { BaseNetWorkUiState } from '@core/base';

@Entry
@ComponentV2
struct MyPage {
  @Local uiState: BaseNetWorkUiState = BaseNetWorkUiState.LOADING;

  build() {
    BaseNetWorkView({
      uiState: this.uiState,
      onRetry: () => {
        // 重试加载
      },
      content: () => {
        // 成功状态下的内容
        Text('数据加载成功');
      }
    });
  }
}
```

**特性：**
- 自动根据 uiState 切换加载/成功/失败状态
- 支持自定义加载视图和错误视图
- 内置平滑过渡动画

#### BaseNetWorkListView - 网络请求列表视图

专为列表场景设计的网络请求视图，支持下拉刷新和上拉加载。

```typescript
import { BaseNetWorkListView } from '@core/components';
import { BaseNetWorkUiState } from '@core/base';

@Entry
@ComponentV2
struct MyListPage {
  @Local uiState: BaseNetWorkUiState = BaseNetWorkUiState.LOADING;
  @Local dataList: Array<Item> = [];
  @Local isRefreshing: boolean = false;
  scroller: Scroller = new Scroller();

  build() {
    BaseNetWorkListView({
      uiState: this.uiState,
      loading: this.isRefreshing,
      scroller: this.scroller,
      onRetry: () => {
        // 重试加载
      },
      onRefresh: (direction) => {
        if (direction === 'pull') {
          // 下拉刷新
        } else {
          // 上拉加载更多
        }
      },
      content: () => {
        List({ scroller: this.scroller }) {
          ForEach(this.dataList, (item: Item) => {
            ListItem() {
              // 列表项内容
            }
          });
        }
      }
    });
  }
}
```

### 刷新布局

#### RefreshLayout - 下拉刷新布局

基于 IBestPullRefresh 封装的下拉刷新组件，支持下拉刷新和上拉加载。

```typescript
import { RefreshLayout } from '@core/components';

@Entry
@ComponentV2
struct MyPage {
  @Local isLoading: boolean = false;
  scroller: Scroller = new Scroller();

  build() {
    RefreshLayout({
      loading: this.isLoading,
      scroller: this.scroller,
      isEnableSlideUp: true,
      onRefresh: (direction) => {
        if (direction === 'pull') {
          // 下拉刷新
        } else {
          // 上拉加载
        }
      },
      content: () => {
        List({ scroller: this.scroller }) {
          // 列表内容
        }
      }
    });
  }
}
```

### 导航组件

#### AppNavDestination - 应用导航目标

自定义的 NavDestination 组件，用于路由导航。

```typescript
import { AppNavDestination } from '@core/components';

AppNavDestination({
  // 导航配置
});
```

## 使用场景

- **缺省页组件**: 空数据、加载失败、网络异常等状态展示
- **加载组件**: 页面加载、数据加载等场景
- **网络请求视图**: 自动化处理网络请求的 UI 状态切换
- **刷新布局**: 列表页面的下拉刷新和上拉加载
- **导航组件**: 页面路由导航

## 与 BaseViewModel 配合使用

components 模块的网络请求视图与 base 模块的 BaseNetWorkViewModel 完美配合：

```typescript
import { BaseNetWorkViewModel, BaseNetWorkUiState } from '@core/base';
import { BaseNetWorkView } from '@core/components';

@ObservedV2
class MyViewModel extends BaseNetWorkViewModel {
  @Trace data: MyData | null = null;

  loadData() {
    this.executeRequest<MyData>(
      this.repository.getData(),
      (data) => {
        this.data = data;
      }
    );
  }
}

@Entry
@ComponentV2
struct MyPage {
  viewModel: MyViewModel = new MyViewModel();

  aboutToAppear() {
    this.viewModel.loadData();
  }

  build() {
    BaseNetWorkView({
      uiState: this.viewModel.uiState,
      onRetry: () => this.viewModel.loadData(),
      content: () => {
        Text(this.viewModel.data?.title);
      }
    });
  }
}
```

## 导入方式

```typescript
import {
  Empty,
  EmptyData,
  EmptyError,
  EmptyNetwork,
  PageLoading,
  BaseNetWorkView,
  BaseNetWorkListView,
  RefreshLayout,
  AppNavDestination
} from '@core/components';
```

## 依赖关系

- **@core/base**: 使用 BaseNetWorkUiState 枚举
- **@core/ibestui**: 使用 IBestEmpty、IBestPullRefresh 等组件
- **@core/designsystem**: 使用设计令牌（尺寸、颜色等）
