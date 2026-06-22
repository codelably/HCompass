# Util Module

工具模块，提供应用开发中常用的工具类，包括日志、Toast、上下文管理、权限申请、本地存储等功能。

## 功能特性

### Logger - 日志工具

基于 HarmonyOS hilog 的日志工具，支持自定义日志写入器和格式化输出。

```typescript
import { Logger, LogLevel } from '@core/util';

// 初始化配置
Logger.init({
  domain: 0xFF00,
  tag: 'MyApp',
  icon: '🗒️',
  close: false
});

// 使用日志
Logger.debug('调试信息');
Logger.info('普通信息');
Logger.warn('警告信息');
Logger.error('错误信息');
Logger.fatal('致命错误');

// 自定义标签
Logger.info('用户登录成功', 'Auth');

// 日志对象
Logger.info({ userId: 123, username: 'test' });
```

**特性：**
- 支持 DEBUG、INFO、WARN、ERROR、FATAL 五个日志级别
- 自动格式化对象为 JSON
- 支持自定义日志写入器（扩展文件、远程服务等）
- 可全局开启/关闭日志输出

### ToastUtils - Toast 提示

封装 IBestToast 的便捷工具类，提供多种样式的 Toast 提示。

```typescript
import { ToastUtils } from '@core/util';

// 基础提示
ToastUtils.show('操作成功');

// 状态提示
ToastUtils.showSuccess('保存成功');
ToastUtils.showError('操作失败');
ToastUtils.showWarning('请注意');

// 加载提示
ToastUtils.showLoading();
ToastUtils.showSpinnerLoading('加载中...');

// 位置提示
ToastUtils.showTop('顶部提示');
ToastUtils.showBottom('底部提示');

// 带图标提示
ToastUtils.showIcon('自定义提示', $r('app.media.icon'));

// 隐藏提示
ToastUtils.hide();
```

### ContextUtil - 上下文管理

统一管理应用上下文，避免在各处传递 context 参数。

```typescript
import { ContextUtil } from '@core/util';

// 在 EntryAbility 中初始化
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    ContextUtil.init(this.context);
  }
}

// 在其他地方使用
const uiAbilityContext = ContextUtil.getUIAbilityCtx();
const uiContext = ContextUtil.getUICtx();
const appContext = ContextUtil.getAppCtx();
const hostContext = ContextUtil.getHostCtx();
```

### PermissionUtils - 权限管理

简化权限申请流程，支持自动二次申请和跳转设置页面。

```typescript
import { PermissionUtils } from '@core/util';

const permissionUtils = new PermissionUtils();

// 申请存储权限
await permissionUtils.requestStoragePermission((granted) => {
  if (granted) {
    // 权限已授予
  } else {
    // 权限被拒绝
  }
});

// 申请相机权限
await permissionUtils.requestCameraPermission((granted) => {
  // 处理结果
});

// 申请录音权限
await permissionUtils.requestAudioPermission((granted) => {
  // 处理结果
});
```

**特性：**
- 自动检查权限状态
- 权限被拒绝时自动二次申请
- 权限被永久拒绝时自动跳转设置页面
- 支持扩展自定义权限申请

### PreferencesUtil - 本地存储

封装 HarmonyOS Preferences API，提供简洁的键值对存储。

```typescript
import { PreferencesUtil } from '@core/util';
import { ContextUtil } from '@core/util';

const prefs = new PreferencesUtil(ContextUtil.getUIAbilityCtx(), 'user_settings');

// 存储数据
await prefs.set('username', 'test');
await prefs.set('age', 25);
await prefs.set('isVip', true);

// 读取数据
const username = await prefs.get('username', '');
const age = await prefs.get('age', 0);

// 删除数据
await prefs.delete('username');

// 清空所有数据
await prefs.clear();
```

### ImageUtil - 图片工具

提供图片处理相关的工具方法（具体功能需查看源码）。

### NotificationUtil - 通知工具

提供系统通知相关的工具方法，支持多种通知样式（具体功能需查看源码）。

## 使用场景

- **Logger**: 应用日志记录、调试信息输出、错误追踪
- **ToastUtils**: 用户操作反馈、状态提示、加载提示
- **ContextUtil**: 统一上下文管理，避免 context 传递
- **PermissionUtils**: 简化权限申请流程，提升用户体验
- **PreferencesUtil**: 用户设置、应用配置、轻量级数据存储

## 初始化

在 EntryAbility 中初始化必要的工具：

```typescript
import { ContextUtil, Logger } from '@core/util';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 初始化上下文
    ContextUtil.init(this.context);

    // 初始化日志
    Logger.init({
      domain: 0xFF00,
      tag: 'MyApp'
    });
  }
}
```

## 导入方式

```typescript
import {
  Logger,
  LogLevel,
  ToastUtils,
  ContextUtil,
  PermissionUtils,
  PreferencesUtil,
  ImageUtil,
  NotificationUtil
} from '@core/util';
```
