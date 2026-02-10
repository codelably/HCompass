# Logger — 日志工具库

一个轻量、可扩展的日志工具，默认基于 `@kit.PerformanceAnalysisKit` 的 `hilog` 实现。

## ✨ 特性

- 🎨 支持 ANSI 颜色输出（可关闭）
- 🔌 可插拔日志写入器（默认使用 `hilog`，可扩展其他写入通道）
- ⚙️ 全局配置：domain、tag、图标、开关等
- 📦 自动格式化对象为带缩进的 JSON
- 🧪 静态调用，无需实例化

## 🚀 快速开始

```ts
import { Logger } from '@core/util';

Logger.debug('This is a debug message');
Logger.info({ name: 'JunBin', age: 25 });
Logger.warn('Warning!');
Logger.error(new Error('Something went wrong'));
```

## ⚙️ 配置

### 全局初始化

```ts
Logger.init({
  domain: 0x1234,
  tag: 'MyApp',
  icon: '🚀',
  enableColor: true,
  close: false // 设为 true 可关闭所有日志
});
```

### 动态开关

```ts
Logger.disable(); // 关闭所有日志
Logger.enable();  // 重新开启
```

### 自定义写入器

```ts
class FileLogWriter extends LogWriter {
  write(level: LogLevel, domain: number, tag: string, message: string): void {
    // 实现写入文件逻辑
    console.log(`[FILE] [${LogLevel[level]}] ${tag}: ${message}`);
  }
}

Logger.setWriter(new FileLogWriter());
// 或在 init 时指定
Logger.init({ tag: 'MyApp' }, new FileLogWriter());
```

## 📝 API

| 方法 | 说明 |
|------|------|
| `Logger.debug(data, tag?)` | 调试日志 |
| `Logger.info(data, tag?)`  | 信息日志 |
| `Logger.warn(data, tag?)`  | 警告日志 |
| `Logger.error(data, tag?)` | 错误日志 |
| `Logger.fatal(data, tag?)` | 致命错误 |
| `Logger.init(option, writer?)` | 初始化配置 |
| `Logger.setWriter(writer)` | 设置自定义写入器 |
| `Logger.enable()` / `disable()` | 开启/关闭日志 |

> `data` 支持任意类型（对象会自动格式化为带图标的 JSON）。

## 🎨 颜色对照表

| 级别 | 颜色 |
|------|------|
| DEBUG | 青色 |
| INFO  | 绿色 |
| WARN  | 黄色 |
| ERROR | 红色 |
| FATAL | 品红 |

> 在不支持 ANSI 的环境（如部分日志查看器）中，建议关闭颜色：`enableColor: false`。

---
