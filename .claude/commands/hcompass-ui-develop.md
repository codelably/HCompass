---
name: hcompass-ui-develop
description: "在 HCompass 框架规范下开发 ArkUI 页面和组件。强制使用框架组件优先级（designsystem → core/components → IBest-UI-V2）、V2 状态管理、布局约束（layoutWeight/百分比/禁硬编码宽高）。触发场景：编写 View 层页面或组件时。"
---

# HCompass UI 开发

## 开发前核查

### 组件选用优先级（依次降级）
1. `core/designsystem`：`RowBase` / `ColumnBase` / `RowCenter` / `ColumnCenter` / `Spacer`
2. `core/components`：`BaseNetWorkView` / `BaseNetWorkListView` / `AppNavDestination` / `Loading` / `Empty`
3. IBest-UI-V2（通过 `core/ibestui` 引入）：Button / Dialog / Toast 等通用 UI
4. 包内私有组件（`packages/<name>/components/`）
5. **禁止重复开发已有组件**

### 布局约束（必须遵守）

| 规则 | 正确 | 禁止 |
|------|------|------|
| 均分布局 | `.layoutWeight(1)` | `FlexAlign.SpaceAround` / `SpaceBetween` |
| 容器宽度 | `width("100%")` 或 `layoutWeight` | `.width(375)` 硬编码 |
| 组件间距 | `Spacer` 组件或百分比 | `.margin({ top: 16 })` 固定值（图标尺寸除外） |
| 图标/固定元素 | 允许 `.width(24).height(24)` | - |

## 编写页面

页面文件位置：`packages/<name>/src/main/ets/view/<Name>Page.ets`

### 标准网络请求页（三态自动管理）

```typescript
/**
 * @file <Name>页面
 * @author JunBin.Yang
 */
import { AppNavDestination, BaseNetWorkView } from "@core/components";
import { ColumnBase } from "@core/designsystem";
import { <Name>ViewModel } from "../viewmodels/<Name>ViewModel";

@ComponentV2
struct <Name>PageContent {
  @Local viewModel: <Name>ViewModel = new <Name>ViewModel();

  @Builder
  contentBuilder() {
    // 仅编写成功态内容，加载/错误态由 BaseNetWorkView 自动处理
    ColumnBase() {
      Text(this.viewModel.data?.title ?? "")
        .fontSize(16)
        .width("100%")
    }
  }

  build() {
    BaseNetWorkView({
      viewModel: this.viewModel,
      contentBuilder: (): void => { this.contentBuilder() }
    })
  }
}

@Builder
export function <name>PageBuilder(name: string, param: object) {
  AppNavDestination({ title: "<页面标题>" }) {
    <Name>PageContent()
  }
}
```

### 标准列表页

```typescript
import { AppNavDestination, BaseNetWorkListView } from "@core/components";
import { <Name>ListViewModel } from "../viewmodels/<Name>ListViewModel";
import { <Name>Item } from "@shared/contracts";

@ComponentV2
struct <Name>ListContent {
  @Local viewModel: <Name>ListViewModel = new <Name>ListViewModel();

  @Builder
  itemBuilder(item: <Name>Item) {
    // 单个列表项 UI
    Row() {
      Text(item.name).layoutWeight(1)
    }
    .width("100%")
    .padding({ horizontal: "4%" })
  }

  build() {
    BaseNetWorkListView({
      viewModel: this.viewModel,
      itemBuilder: (item: <Name>Item): void => { this.itemBuilder(item) }
    })
  }
}
```

### 纯本地状态页

```typescript
@ComponentV2
struct <Name>Page {
  @Local viewModel: <Name>ViewModel = new <Name>ViewModel();

  build() {
    ColumnBase() {
      // 页面内容，View 层只负责渲染
      // 调用 this.viewModel.xxx 读取数据
      // 调用 this.viewModel.doXxx() 触发操作
    }
    .width("100%")
    .height("100%")
  }
}
```

## 编写可复用组件

```typescript
/**
 * @file <Name>组件
 * @author JunBin.Yang
 */
@ComponentV2
export struct <Name>Component {
  /** 标题文本 */
  @Param title: string = "";
  /** 点击回调 */
  @Event onTap: () => void = () => {};

  build() {
    Row() {
      Text(this.title)
        .fontSize(14)
        .layoutWeight(1)
    }
    .width("100%")
    .onClick(() => { this.onTap(); })
  }
}
```

## 状态管理规范（V2 强制）

```typescript
// 组件本地状态：@Local（禁用 @State）
@Local isVisible: boolean = false;

// 接收父组件参数：@Param（禁用 @Prop）
@Param title: string = "";

// 事件回调：@Event（禁用 @Link）
@Event onChange: (value: string) => void = () => {};

// ViewModel 绑定
@Local viewModel: MyViewModel = new MyViewModel();
```

## 代码规范检查

- 文件头必须含 `@file` + `@author JunBin.Yang`
- View 层不含任何业务逻辑（网络请求/数据处理/计算）
- 禁止在 View 层直接 import Model 类型（通过 ViewModel 访问）
- 所有方法必须有 JSDoc 注释（`@param` / `@returns`）
- 禁止使用 `any` 类型
- 字符串使用双引号，语句末尾加分号
