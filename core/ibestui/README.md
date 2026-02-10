# IBestUI Module

IBestUI 组件库集成模块，封装 IBestUI v2 组件库并提供统一的初始化管理。

## 介绍

ibestui 模块是对 `@ibestservices/ibest-ui-v2` 的封装和导出，提供丰富的 UI 组件和统一的初始化接口。IBestUI 是一个专为 HarmonyOS 设计的高质量 UI 组件库。

## 功能特性

- **丰富的组件**: 提供 50+ 常用 UI 组件
- **统一初始化**: 封装初始化逻辑，简化使用
- **主题定制**: 支持自定义主题颜色
- **开箱即用**: 无需复杂配置，快速上手

## 快速开始

### 1. 初始化 IBestUI

在 EntryAbility 中初始化 IBestUI：

```typescript
import { IBestUIInitializer } from '@core/ibestui';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        return;
      }

      // 初始化 IBestUI
      IBestUIInitializer.initIBestUI(windowStage, this.context);
    });
  }
}
```

### 2. 使用 IBestUI 组件

```typescript
import {
  IBestButton,
  IBestToast,
  IBestDialog,
  IBestEmpty,
  IBestPullRefresh
} from '@core/ibestui';

@Entry
@ComponentV2
struct MyPage {
  build() {
    Column() {
      // 按钮组件
      IBestButton({
        text: '点击我',
        type: 'primary',
        onClickBtn: () => {
          IBestToast.show('按钮被点击');
        }
      });

      // 空状态组件
      IBestEmpty({
        description: '暂无数据'
      });
    }
  }
}
```

## 常用组件

### 基础组件

- **IBestButton**: 按钮组件
- **IBestIcon**: 图标组件
- **IBestImage**: 图片组件
- **IBestCell**: 单元格组件
- **IBestCellGroup**: 单元格组组件

### 表单组件

- **IBestInput**: 输入框组件
- **IBestTextarea**: 文本域组件
- **IBestRadio**: 单选框组件
- **IBestCheckbox**: 复选框组件
- **IBestSwitch**: 开关组件
- **IBestStepper**: 步进器组件
- **IBestRate**: 评分组件
- **IBestSlider**: 滑块组件
- **IBestPicker**: 选择器组件
- **IBestDatePicker**: 日期选择器组件

### 反馈组件

- **IBestToast**: 轻提示组件
- **IBestDialog**: 对话框组件
- **IBestLoading**: 加载组件
- **IBestNotify**: 通知组件
- **IBestActionSheet**: 动作面板组件
- **IBestOverlay**: 遮罩层组件

### 展示组件

- **IBestEmpty**: 空状态组件
- **IBestTag**: 标签组件
- **IBestBadge**: 徽标组件
- **IBestProgress**: 进度条组件
- **IBestSkeleton**: 骨架屏组件
- **IBestSteps**: 步骤条组件
- **IBestNoticeBar**: 通知栏组件
- **IBestSwipe**: 轮播组件

### 导航组件

- **IBestTabs**: 标签页组件
- **IBestNavBar**: 导航栏组件
- **IBestTabBar**: 标签栏组件
- **IBestSidebar**: 侧边导航组件

### 业务组件

- **IBestPullRefresh**: 下拉刷新组件
- **IBestList**: 列表组件
- **IBestGrid**: 宫格组件
- **IBestIndexBar**: 索引栏组件
- **IBestSearch**: 搜索组件

## 主题定制

### 自定义主题颜色

修改 IBestUIInitializer 中的主题配置：

```typescript
// IBestUIInitializer.ets
static setIBestUIBaseStyle(): void {
  IBestSetUIBaseStyle({
    primary: $r("app.color.primary"),    // 主色
    success: $r("app.color.success"),    // 成功色
    warning: $r("app.color.warning"),    // 警告色
    danger: $r("app.color.danger"),      // 危险色
  });
}
```

在 `entry/src/main/resources/base/element/color.json` 中定义颜色：

```json
{
  "color": [
    {
      "name": "primary",
      "value": "#1989fa"
    },
    {
      "name": "success",
      "value": "#07c160"
    },
    {
      "name": "warning",
      "value": "#ff976a"
    },
    {
      "name": "danger",
      "value": "#ee0a24"
    }
  ]
}
```

## 使用示例

### Toast 提示

```typescript
import { IBestToast } from '@core/ibestui';

// 普通提示
IBestToast.show('操作成功');

// 成功提示
IBestToast.show({
  type: 'success',
  message: '保存成功'
});

// 失败提示
IBestToast.show({
  type: 'fail',
  message: '操作失败'
});

// 加载提示
IBestToast.showLoading();
IBestToast.hide();  // 隐藏
```

### Dialog 对话框

```typescript
import { IBestDialog } from '@core/ibestui';

IBestDialog.show({
  title: '提示',
  message: '确定要删除吗？',
  showCancelButton: true,
  onConfirm: () => {
    // 确认操作
  },
  onCancel: () => {
    // 取消操作
  }
});
```

### PullRefresh 下拉刷新

```typescript
import { IBestPullRefresh } from '@core/ibestui';

@Entry
@ComponentV2
struct MyPage {
  @Local loading: boolean = false;
  scroller: Scroller = new Scroller();

  build() {
    IBestPullRefresh({
      loading: this.loading,
      scroller: this.scroller,
      onRefresh: () => {
        this.loading = true;
        // 加载数据
        setTimeout(() => {
          this.loading = false;
        }, 2000);
      },
      defaultContent: () => {
        List({ scroller: this.scroller }) {
          // 列表内容
        }
      }
    });
  }
}
```

## 在项目中的使用

### 与 ToastUtils 配合

```typescript
import { ToastUtils } from '@core/util';

// ToastUtils 内部使用 IBestToast
ToastUtils.show('提示信息');
ToastUtils.showSuccess('成功');
ToastUtils.showError('失败');
```

### 与 Empty 组件配合

```typescript
import { Empty } from '@core/components';

// Empty 组件内部使用 IBestEmpty
Empty({
  imageRes: $r('app.media.empty'),
  description: '暂无数据'
});
```

### 与 RefreshLayout 配合

```typescript
import { RefreshLayout } from '@core/components';

// RefreshLayout 内部使用 IBestPullRefresh
RefreshLayout({
  loading: this.loading,
  scroller: this.scroller,
  onRefresh: (direction) => {
    // 刷新逻辑
  },
  content: () => {
    // 内容
  }
});
```

## 注意事项

1. **初始化时机**: 必须在 onWindowStageCreate 中初始化
2. **上下文依赖**: 需要传入 windowStage 和 context
3. **主题配置**: 主题颜色需要在资源文件中定义
4. **版本兼容**: 确保使用的是 IBestUI v2 版本

## 更多信息

IBestUI 的详细文档和 API 参考，请访问：
- GitHub: https://github.com/ibestservices/ibest-ui
- 官方文档: [IBestUI Documentation]
- 组件示例: 查看 demo 包中的示例页面

## 导入方式

```typescript
// 导出所有 IBestUI 的组件
import {
  IBestButton,
  IBestToast,
  IBestDialog,
  IBestEmpty,
  IBestPullRefresh,
  // ... 其他组件
} from '@core/ibestui';

// 导入初始化器
import { IBestUIInitializer } from '@core/ibestui';
```

## 依赖关系

- **@ibestservices/ibest-ui-v2**: IBestUI v2 核心库
- **entry/resources**: 依赖应用资源文件中定义的主题颜色
