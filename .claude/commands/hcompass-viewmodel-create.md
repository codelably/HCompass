---
name: hcompass-viewmodel-create
description: "在 HCompass 框架中创建符合规范的 ViewModel。提供三种基类选择决策树（BaseViewModel / BaseNetWorkViewModel / BaseNetWorkListViewModel），含 @ObservedV2/@Trace 装饰、DI 服务注入、生命周期钩子的完整实现模式。触发场景：需要为页面或组件创建 ViewModel 时。"
---

# 创建 HCompass ViewModel

## 第一步：选择基类

```
需要网络请求吗？
├─→ 不需要 → BaseViewModel
│     用于：纯本地逻辑、数据库操作、只有 UI 状态的页面
│
└─→ 需要
    ├─→ 单条数据/详情页 → BaseNetWorkViewModel<T>
    │     自动管理 uiState（LOADING/SUCCESS/ERROR）和 data
    │     在 aboutToAppear 时自动触发请求，支持 retryRequest()
    │
    └─→ 列表/分页数据 → BaseNetWorkListViewModel<T>
          内置分页逻辑，管理列表数据和加载更多状态
```

## 第二步：创建文件

文件位置：`packages/<name>/src/main/ets/viewmodels/<Name>ViewModel.ets`

### 模式一：BaseViewModel

```typescript
/**
 * @file <Name>ViewModel - <功能描述>
 * @author JunBin.Yang
 */
import { BaseViewModel } from "@core/base";
import { getContainer } from "@core/di";
import { <NAME>_SVC_KEY, I<Name>Service } from "@shared/contracts";

@ObservedV2
export class <Name>ViewModel extends BaseViewModel {
  /** <字段说明> */
  @Trace <fieldName>: <Type> = <defaultValue>;

  private <name>Service: I<Name>Service;

  constructor() {
    super();
    this.<name>Service = getContainer().resolve<I<Name>Service>(<NAME>_SVC_KEY);
  }

  /** 页面显示时触发 */
  override onShown(reason?: string): void {
    super.onShown(reason);
    this.loadData();
  }

  /**
   * 加载数据
   */
  async loadData(): Promise<void> {
    try {
      const result = await this.<name>Service.getData();
      // 不可变更新：创建新对象/数组
      this.<fieldName> = { ...result };
    } catch (error) {
      // 处理错误
    }
  }
}
```

### 模式二：BaseNetWorkViewModel（单条数据）

```typescript
/**
 * @file <Name>ViewModel - <功能描述>
 * @author JunBin.Yang
 */
import { BaseNetWorkViewModel } from "@core/base";
import { NetworkResult } from "@core/network";
import { getContainer } from "@core/di";
import { <NAME>_SVC_KEY, I<Name>Service, <Name>Data } from "@shared/contracts";

@ObservedV2
export class <Name>ViewModel extends BaseNetWorkViewModel<<Name>Data> {
  private <name>Service: I<Name>Service;

  constructor() {
    super();
    this.<name>Service = getContainer().resolve<I<Name>Service>(<NAME>_SVC_KEY);
  }

  /**
   * 框架自动在 aboutToAppear 时调用，实现数据加载逻辑
   */
  protected requestRepository(): Promise<NetworkResult<<Name>Data>> {
    return this.<name>Service.getData();
  }
}
```

View 层通过 `BaseNetWorkView` 自动渲染三态（加载/成功/错误）：
```typescript
BaseNetWorkView({ viewModel: this.viewModel, contentBuilder: () => {
  // 只编写成功态的内容
  this.contentBuilder()
}})
```

### 模式三：BaseNetWorkListViewModel（列表分页）

```typescript
/**
 * @file <Name>ListViewModel - <功能描述>
 * @author JunBin.Yang
 */
import { BaseNetWorkListViewModel } from "@core/base";
import { NetworkResult } from "@core/network";
import { getContainer } from "@core/di";
import { <NAME>_SVC_KEY, I<Name>Service, <Name>Item } from "@shared/contracts";

@ObservedV2
export class <Name>ListViewModel extends BaseNetWorkListViewModel<<Name>Item> {
  private <name>Service: I<Name>Service;

  constructor() {
    super();
    this.<name>Service = getContainer().resolve<I<Name>Service>(<NAME>_SVC_KEY);
  }

  protected requestRepository(page: number, pageSize: number): Promise<NetworkResult<<Name>Item[]>> {
    return this.<name>Service.getList(page, pageSize);
  }
}
```

## 第三步：生命周期钩子映射

| ViewModel 钩子 | 触发时机 | 适用场景 |
|--------------|---------|---------|
| `aboutToAppear()` | 组件创建后、build 前 | 初始化数据、注册监听 |
| `onShown(reason)` | NavDestination 页面显示 | 每次进入页面刷新数据 |
| `onHidden(reason)` | NavDestination 页面隐藏 | 暂停动画、释放资源 |
| `aboutToDisappear()` | 页面销毁前 | 清理资源、取消监听 |

## 第四步：在 View 中使用

```typescript
@ComponentV2
struct <Name>Page {
  @Local viewModel: <Name>ViewModel = new <Name>ViewModel();

  build() {
    // 使用 this.viewModel.<property> 读取数据
    // 调用 this.viewModel.<method>() 触发操作
  }
}
```

## 不可变性要求（必须遵守）

```typescript
// 数组操作 - 必须创建新数组
this.list = [...this.list, newItem];           // 追加
this.list = this.list.filter(i => i.id !== id); // 删除

// 对象操作 - 必须创建新对象
this.userInfo = { ...this.userInfo, name: "新名字" };

// 禁止直接修改
this.list.push(newItem);        // 禁止
this.userInfo.name = "新名字";  // 禁止
```
