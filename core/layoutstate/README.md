# Layout State Module

布局状态管理模块，提供响应式断点和窗口安全区管理，支持多设备适配和沉浸式布局。

## 功能特性

### BreakpointState - 响应式断点

管理窗口尺寸断点，实现响应式布局适配不同屏幕尺寸。

#### 断点规则

- **XS (Extra Small)**: 0 - 320vp（超小屏幕）
- **SM (Small)**: 321 - 600vp（小屏幕，手机竖屏）
- **MD (Medium)**: 601 - 840vp（中等屏幕，手机横屏/小平板）
- **LG (Large)**: 841vp+（大屏幕，平板/桌面）

#### 使用方法

```typescript
import { getBreakpointState, BreakpointType } from '@core/layoutstate';

@Entry
@ComponentV2
struct MyPage {
  // 获取全局断点状态
  breakpointState = getBreakpointState();

  build() {
    Column() {
      // 根据断点显示不同内容
      if (this.breakpointState.isSM()) {
        Text('小屏幕布局');
      } else if (this.breakpointState.isMD()) {
        Text('中等屏幕布局');
      } else {
        Text('大屏幕布局');
      }

      // 使用 bp() 辅助函数
      Text('标题')
        .fontSize(this.breakpointState.bp({
          xs: 14,
          sm: 16,
          md: 18,
          lg: 20
        }));
    }
  }
}
```

#### 初始化断点状态

在 EntryAbility 中监听窗口尺寸变化：

```typescript
import { getBreakpointState } from '@core/layoutstate';
import { window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        return;
      }

      const breakpointState = getBreakpointState();
      const mainWindow = windowStage.getMainWindowSync();

      // 初始化断点
      const windowProperties = mainWindow.getWindowProperties();
      const windowRect = windowProperties.windowRect;
      breakpointState.updateByWidth(px2vp(windowRect.width));

      // 监听窗口尺寸变化
      mainWindow.on('windowSizeChange', (size) => {
        breakpointState.updateByWidth(px2vp(size.width));
      });
    });
  }
}
```

#### API 参考

**BreakpointState 类**

| 方法 | 说明 | 返回值 |
|------|------|--------|
| `updateByWidth(windowWidthVp)` | 更新窗口宽度并计算断点 | void |
| `isXS()` | 是否为超小断点 | boolean |
| `isSM()` | 是否为小断点 | boolean |
| `isMD()` | 是否为中断点 | boolean |
| `isLG()` | 是否为大断点 | boolean |
| `bp(options)` | 根据当前断点返回对应值 | T |

**bp() 辅助函数**

```typescript
// 为不同断点设置不同的值
const fontSize = breakpointState.bp({
  xs: 12,
  sm: 14,
  md: 16,
  lg: 18
});

// 支持部分断点，未指定的使用最近的较小断点值
const padding = breakpointState.bp({
  sm: 8,
  lg: 16
});
```

### WindowSafeAreaState - 窗口安全区

管理窗口安全区域（状态栏、导航栏等），用于沉浸式布局的避让。

#### 使用方法

```typescript
import { getWindowSafeAreaState } from '@core/layoutstate';

@Entry
@ComponentV2
struct MyPage {
  // 获取全局安全区状态
  safeAreaState = getWindowSafeAreaState();

  build() {
    Column() {
      // 顶部避让状态栏
      Blank()
        .height(this.safeAreaState.topInset);

      Text('内容区域');

      // 底部避让导航栏
      Blank()
        .height(this.safeAreaState.bottomInset);
    }
  }
}
```

#### 初始化安全区状态

在 EntryAbility 中获取安全区信息：

```typescript
import { getWindowSafeAreaState } from '@core/layoutstate';
import { window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        return;
      }

      const safeAreaState = getWindowSafeAreaState();
      const mainWindow = windowStage.getMainWindowSync();

      // 获取安全区信息
      const avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      safeAreaState.updateSafeArea(
        px2vp(avoidArea.topRect.height),
        px2vp(avoidArea.leftRect.width),
        px2vp(avoidArea.bottomRect.height),
        px2vp(avoidArea.rightRect.width)
      );
    });
  }
}
```

#### API 参考

**WindowSafeAreaState 类**

| 属性 | 说明 | 类型 |
|------|------|------|
| `topInset` | 顶部安全区高度（vp） | number |
| `leftInset` | 左侧安全区宽度（vp） | number |
| `bottomInset` | 底部安全区高度（vp） | number |
| `rightInset` | 右侧安全区宽度（vp） | number |

| 方法 | 说明 | 返回值 |
|------|------|--------|
| `updateSafeArea(top, left, bottom, right)` | 更新安全区数据 | void |
| `updateSafeAreaByInsets(insets)` | 更新安全区数据（结构体方式） | void |

## 使用场景

### 响应式布局

根据屏幕尺寸调整布局：

```typescript
@Entry
@ComponentV2
struct ResponsivePage {
  breakpointState = getBreakpointState();

  build() {
    if (this.breakpointState.isSM()) {
      // 手机竖屏：单列布局
      Column() {
        this.buildContent();
      }
    } else {
      // 平板/横屏：双列布局
      Row() {
        Column()
          .width(P50)
          .layoutWeight(1);

        Column()
          .width(P50)
          .layoutWeight(1);
      }
    }
  }

  @Builder
  buildContent() {
    // 内容
  }
}
```

### 沉浸式布局

实现全屏沉浸式效果：

```typescript
@Entry
@ComponentV2
struct ImmersivePage {
  safeAreaState = getWindowSafeAreaState();

  build() {
    Stack() {
      // 背景图片全屏显示
      Image($r('app.media.background'))
        .width(P100)
        .height(P100);

      // 内容区域避让安全区
      Column() {
        // 顶部避让
        Blank().height(this.safeAreaState.topInset);

        // 内容
        Text('标题');

        // 底部避让
        Blank().height(this.safeAreaState.bottomInset);
      }
    }
  }
}
```

### 动态字体大小

根据屏幕尺寸调整字体：

```typescript
@Entry
@ComponentV2
struct DynamicFontPage {
  breakpointState = getBreakpointState();

  build() {
    Column() {
      Text('标题')
        .fontSize(this.breakpointState.bp({
          xs: 18,
          sm: 20,
          md: 24,
          lg: 28
        }));

      Text('正文')
        .fontSize(this.breakpointState.bp({
          xs: 14,
          sm: 16,
          md: 18,
          lg: 20
        }));
    }
  }
}
```

## 完整初始化示例

在 EntryAbility 中同时初始化断点和安全区：

```typescript
import { getBreakpointState, getWindowSafeAreaState } from '@core/layoutstate';
import { window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        return;
      }

      const mainWindow = windowStage.getMainWindowSync();

      // 初始化断点状态
      this.initBreakpointState(mainWindow);

      // 初始化安全区状态
      this.initSafeAreaState(mainWindow);
    });
  }

  private initBreakpointState(mainWindow: window.Window): void {
    const breakpointState = getBreakpointState();

    // 初始化
    const windowProperties = mainWindow.getWindowProperties();
    const windowRect = windowProperties.windowRect;
    breakpointState.updateByWidth(px2vp(windowRect.width));

    // 监听变化
    mainWindow.on('windowSizeChange', (size) => {
      breakpointState.updateByWidth(px2vp(size.width));
    });
  }

  private initSafeAreaState(mainWindow: window.Window): void {
    const safeAreaState = getWindowSafeAreaState();

    // 获取安全区
    const avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    safeAreaState.updateSafeArea(
      px2vp(avoidArea.topRect.height),
      px2vp(avoidArea.leftRect.width),
      px2vp(avoidArea.bottomRect.height),
      px2vp(avoidArea.rightRect.width)
    );
  }
}
```

## 注意事项

1. **全局状态**: 两个状态都是全局单例，通过 AppStorageV2 管理
2. **初始化时机**: 必须在 onWindowStageCreate 中初始化
3. **响应式更新**: 状态变化会自动触发 UI 更新
4. **单位转换**: 窗口 API 返回的是 px，需要转换为 vp

## 导入方式

```typescript
import {
  getBreakpointState,
  BreakpointState,
  BreakpointType,
  getWindowSafeAreaState,
  WindowSafeAreaState
} from '@core/layoutstate';
```

## 依赖关系

- **@kit.ArkUI**: 使用 AppStorageV2 和 window API
- 无其他核心模块依赖
