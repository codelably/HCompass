# Design System Module

设计系统模块，提供统一的设计令牌（Design Tokens）、布局常量和组件属性扩展，确保应用 UI 的一致性。

## 功能特性

### 布局百分比常量

提供 0% 到 100% 的百分比常量，以 5% 为间隔，用于快速设置组件尺寸。

```typescript
import { P0, P50, P100 } from '@core/designsystem';

Column() {
  Text('半宽')
    .width(P50);

  Text('全宽')
    .width(P100);
}
```

**可用常量：**
- `P0` - `P100`: 0% 到 100%，每 5% 一个常量
- 常用值: `P0`, `P25`, `P50`, `P75`, `P100`

### 间距组件

提供标准化的垂直和水平间距组件，确保应用内间距的一致性。

#### 垂直间距

```typescript
import {
  SpaceVerticalXXLarge,  // 32vp
  SpaceVerticalXLarge,   // 24vp
  SpaceVerticalLarge,    // 16vp
  SpaceVerticalMedium,   // 12vp
  SpaceVerticalSmall,    // 8vp
  SpaceVerticalXSmall    // 4vp
} from '@core/designsystem';

Column() {
  Text('标题');
  SpaceVerticalMedium();  // 12vp 间距
  Text('内容');
  SpaceVerticalLarge();   // 16vp 间距
  Text('底部');
}
```

#### 水平间距

```typescript
import {
  SpaceHorizontalXXLarge,  // 32vp
  SpaceHorizontalXLarge,   // 24vp
  SpaceHorizontalLarge,    // 16vp
  SpaceHorizontalMedium,   // 12vp
  SpaceHorizontalSmall,    // 8vp
  SpaceHorizontalXSmall    // 4vp
} from '@core/designsystem';

Row() {
  Text('左侧');
  SpaceHorizontalMedium();  // 12vp 间距
  Text('右侧');
}
```

**间距规范：**
- **XXLarge (32vp)**: 页面级别的大间距
- **XLarge (24vp)**: 模块之间的间距
- **Large (16vp)**: 组件之间的间距
- **Medium (12vp)**: 元素之间的标准间距
- **Small (8vp)**: 紧凑布局的间距
- **XSmall (4vp)**: 最小间距

### 属性扩展

#### size - 快速设置相同宽高

```typescript
import { size } from '@core/designsystem';

// 设置 24x24 的正方形
Image($r('app.media.icon'))
  .attributeModifier(size(24));

// 等价于
Image($r('app.media.icon'))
  .width(24)
  .height(24);
```

### 增强组件

提供增强版的基础组件，添加了额外的属性和功能。

#### Column / Row / Scroll

增强版的布局组件，提供更多便捷属性（具体功能需查看源码）。

```typescript
import { Column, Row, Scroll } from '@core/designsystem';

// 使用增强版组件
Column() {
  // 内容
}
```

## 使用场景

- **布局百分比**: 响应式布局、弹性尺寸设置
- **间距组件**: 统一应用内的间距规范，提升 UI 一致性
- **属性扩展**: 简化常用属性设置，减少代码重复
- **增强组件**: 提供更强大的布局能力

## 设计原则

### 1. 一致性

使用统一的设计令牌确保整个应用的视觉一致性：

```typescript
// 好的做法 - 使用设计令牌
Column() {
  Text('标题');
  SpaceVerticalMedium();
  Text('内容');
}

// 不好的做法 - 硬编码数值
Column() {
  Text('标题');
  Blank().height(12);  // 魔法数字
  Text('内容');
}
```

### 2. 可维护性

集中管理设计令牌，修改时只需更新一处：

```typescript
// 如果需要调整标准间距，只需修改 space_vertical_medium 资源
// 所有使用 SpaceVerticalMedium() 的地方都会自动更新
```

### 3. 语义化

使用语义化的命名，提高代码可读性：

```typescript
// 清晰表达意图
SpaceVerticalLarge();  // 大间距

// 而不是
Blank().height(16);    // 不清楚为什么是 16
```

## 扩展设计系统

### 添加新的间距规范

在 `entry/src/main/resources/base/element/float.json` 中定义：

```json
{
  "float": [
    {
      "name": "space_vertical_custom",
      "value": "20vp"
    }
  ]
}
```

然后在 Spacer.ets 中添加对应的组件：

```typescript
@Builder
export function SpaceVerticalCustom(): void {
  Blank().height($r("app.float.space_vertical_custom"));
}
```

### 添加新的属性扩展

在 CommonAttribute.ets 中添加新的属性修饰器：

```typescript
export function padding(value: Length): AttributeModifier<CommonAttribute> {
  return {
    applyNormalAttribute: (instance: CommonAttribute): void => {
      instance.padding(value);
    }
  };
}
```

## 最佳实践

### 1. 优先使用设计令牌

```typescript
// 推荐
.width(P100)
.padding(SpaceHorizontalMedium())

// 避免
.width('100%')
.padding(12)
```

### 2. 保持间距一致

在同一层级的元素间使用相同的间距：

```typescript
Column() {
  Text('项目 1');
  SpaceVerticalMedium();
  Text('项目 2');
  SpaceVerticalMedium();
  Text('项目 3');
}
```

### 3. 响应式布局

结合百分比常量实现响应式布局：

```typescript
Row() {
  Column()
    .width(P30)  // 左侧 30%

  Column()
    .width(P70)  // 右侧 70%
}
```

## 导入方式

```typescript
// 百分比常量
import { P0, P25, P50, P75, P100 } from '@core/designsystem';

// 间距组件
import {
  SpaceVerticalLarge,
  SpaceVerticalMedium,
  SpaceHorizontalLarge,
  SpaceHorizontalMedium
} from '@core/designsystem';

// 属性扩展
import { size } from '@core/designsystem';

// 增强组件
import { Column, Row, Scroll } from '@core/designsystem';
```

## 依赖关系

- **entry/resources**: 依赖应用资源文件中定义的间距值
- 无其他核心模块依赖，可独立使用
