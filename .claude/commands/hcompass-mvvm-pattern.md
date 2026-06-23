---
name: hcompass-mvvm-pattern
description: "HCompass 框架的 MVVM 分层设计与整改向导。基于 BaseViewModel/BaseNetWorkViewModel/BaseNetWorkListViewModel 体系，严格 V2 状态管理，含新建工作流和现有代码整改工作流。触发场景：设计新功能的分层结构，或整改不符合 MVVM 规范的代码。"
---

# HCompass MVVM 架构模式

## 框架分层职责

| 层 | 位置 | 职责 | 禁止 |
|----|------|------|------|
| View | `view/` | 渲染 UI，绑定 ViewModel | 业务逻辑、网络请求、import Model |
| ViewModel | `viewmodels/` | UI 状态管理，调用 Service | 直接操作 UI 组件 |
| Service | `services/` | 实现业务逻辑，封装数据源 | 持有 UI 状态 |
| DataSource | `services/datasource/` | 网络/本地数据访问 | 业务逻辑 |
| Model | `models/` | 纯数据结构 | 装饰器、UI 依赖 |

## 基类选择

```
需要网络请求？
├─→ 否 → BaseViewModel（本地逻辑、数据库、纯 UI 状态）
└─→ 是
    ├─→ 单条数据/详情 → BaseNetWorkViewModel<T>
    └─→ 列表/分页 → BaseNetWorkListViewModel<T>
```

## ViewModel 规范

### 属性装饰器规范（V2 强制）

```typescript
@ObservedV2
export class MyViewModel extends BaseViewModel {
  @Trace data: MyData | null = null;      // 驱动 UI 渲染的属性
  @Trace isLoading: boolean = false;      // UI 状态

  // 计算属性（不存储，从现有属性派生）
  get canSubmit(): boolean {
    return this.inputText.length > 0;
  }

  // 禁止：业务无关的 UI 状态放入 ViewModel
  // 禁止：直接修改数组/对象（必须创建新实例）
}
```

### 状态变量归属决策

```
这个值能从已有属性计算出来？
├─→ 能 → getter 计算属性，不存储
└─→ 不能
    ├─→ 只有一个组件用 → @Local（组件级）
    ├─→ 多个组件共享但仅 UI 展示 → @Param 向下传递
    └─→ 涉及业务逻辑/数据 → ViewModel @Trace 属性
```

## 新建功能工作流

### 1. 定义 Model（纯数据）

```typescript
// models/OrderModel.ets - 纯接口，无装饰器
export interface OrderModel {
  id: string;
  amount: number;
  status: "pending" | "paid";
}
```

### 2. 创建 ViewModel

```typescript
@ObservedV2
export class OrderViewModel extends BaseNetWorkViewModel<OrderModel> {
  @Trace orderId: string = "";

  private orderService: IOrderService;

  constructor() {
    super();
    this.orderService = getContainer().resolve<IOrderService>(ORDER_SVC_KEY);
  }

  protected requestRepository(): Promise<NetworkResult<OrderModel>> {
    return this.orderService.getOrder(this.orderId);
  }
}
```

### 3. 实现 View（只渲染）

```typescript
@ComponentV2
struct OrderPage {
  @Local viewModel: OrderViewModel = new OrderViewModel();

  @Builder
  contentBuilder() {
    // 成功态内容
    Text(`订单金额：${this.viewModel.data?.amount}`)
  }

  build() {
    BaseNetWorkView({
      viewModel: this.viewModel,
      contentBuilder: (): void => { this.contentBuilder() }
    })
  }
}
```

## 整改工作流（已有代码 → MVVM）

### 排查清单

- [ ] Page/View 中存在网络请求或业务逻辑 → 提取到 ViewModel
- [ ] `@State` 变量含业务数据（非纯 UI 状态）→ 迁移到 ViewModel `@Trace`
- [ ] View 层直接 import Model 文件 → 删除，通过 ViewModel 访问
- [ ] 多处管理同一份数据 → 统一到单一 ViewModel
- [ ] 使用 V1 装饰器（`@State/@Prop/@Observed`）→ 迁移至 V2（参考 `/hcompass-statemgt-v2`）

### 整改顺序

1. 纯展示页（无交互）→ 风险最低，先整改
2. 简单表单页
3. 有增删改的列表页
4. 多 Tab / 嵌套导航页（最复杂，最后整改）

### 每页整改步骤

```
① 新建 XxxViewModel 文件
② 将 Page 中的 @State 业务变量迁移到 ViewModel（加 @Trace）
③ 将 Page 中的业务方法迁移到 ViewModel
④ 将网络/数据库调用迁移到 Service / DataSource 层
⑤ Page 改为 @Local viewModel = new XxxViewModel()，只保留 UI 组装
⑥ 运行 /hcompass-syntax-checker 验证编译
```

## 不可变性强制规则

```typescript
// 数组
this.list = [...this.list, newItem];              // 追加
this.list = this.list.filter(i => i.id !== id);   // 删除
this.list = this.list.map(i =>
  i.id === id ? { ...i, name: "新名字" } : i      // 更新某项
);

// 对象
this.userInfo = { ...this.userInfo, age: 25 };

// 禁止
this.list.push(item);           // 直接 push
this.userInfo.age = 25;         // 直接赋值属性
```
