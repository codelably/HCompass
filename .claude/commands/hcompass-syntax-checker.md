---
name: hcompass-syntax-checker
description: "HCompass 项目构建检查与自动修复。静态检查 .ets 文件 → 修复错误 → hvigorw 构建，最多5轮循环直到成功。了解 HCompass 四层模块结构，优先排查多模块依赖路径、Index.ets 导出遗漏、V2 装饰器语法错误。触发场景：编码完成后验证构建、出现编译错误时修复。"
---

# HCompass 项目构建检查

## 工作流程

```
步骤0: 检查MCP工具（mcp_codegenie-mcp_check_ets_files / mcp_codegenie-mcp_build_project）
  └─→ 不可用 → 提示安装，终止

步骤1: 扫描项目 .ets 文件（排除 oh_modules/ build/ .preview/）

步骤2: 静态语法检查
  └─→ mcp_codegenie-mcp_check_ets_files

步骤3: 分析诊断结果
  ├─→ 有 P0 错误 → 步骤4修复 → 返回步骤2
  └─→ 无错误 → 步骤5构建

步骤4: 按优先级修复错误（P0必须 → P1建议 → P2可选）

步骤5: 执行构建
  └─→ hvigorw assembleHap -p product=default

步骤6: 构建结果
  ├─→ 成功 → 输出产物路径，完成
  └─→ 失败 → 分析错误 → 步骤4
      重试次数 > 5 → 终止，输出失败报告
```

## HCompass 特有错误优先排查

### 多模块依赖路径问题

`oh-package.json5` 中依赖路径格式必须为：
```json5
"dependencies": {
  "@core/base": "file:../../core/base",
  "@shared/contracts": "file:../../shared/contracts"
}
```
常见错误：路径层级错误、依赖未声明、模块名与目录不匹配。

### Index.ets 导出遗漏

新增类/函数后必须在对应模块的 `Index.ets` 中导出：
```typescript
// packages/user/Index.ets
export { UserModule, createUserModule } from './src/main/ets/UserModule';
export { UserViewModel } from './src/main/ets/viewmodels/UserViewModel';
```
错误表现：其他模块引用时提示"找不到模块"或"未导出"。

### V2 装饰器语法错误

| 错误表现 | 根因 | 修复 |
|---------|------|------|
| `@State` 在 `@ComponentV2` 中 | V1/V2 混用 | 改为 `@Local` |
| `@Observed` 类缺少 `@Trace` | V2 属性不可观测 | 给属性添加 `@Trace` |
| `@Param` 属性在组件内被修改 | V2 `@Param` 只读 | 通过 `@Event` 回调修改 |
| `AppStorage` 在 V2 组件中 | V1 API | 改为 `AppStorageV2` |

### 模块注册问题

Entry 层的 `EntryAbility.ets` 中模块注册顺序必须满足依赖关系：
```typescript
// 被依赖的模块先注册
registry.register(createAuthModule());    // auth 无依赖
registry.register(createUserModule());    // user 依赖 auth
```
循环依赖会在 `ModuleRegistry.bootstrap()` 时抛出异常。

## 错误优先级

| 级别 | 说明 | 处理 |
|------|------|------|
| P0 | 语法/类型错误，阻止编译 | 必须修复 |
| P1 | 废弃 API（code: 6387） | 强烈建议修复 |
| P2 | 未使用变量（code: 6133）、权限警告（code: 28007） | 可选 |

## MCP 工具不可用时

MCP 工具不可用时，直接执行构建命令并分析输出：
```bash
hvigorw assembleHap -p product=default
```
根据错误日志手动定位问题，重点关注 `ERROR` 行。

## 构建产物位置

```
entry/build/default/outputs/default/entry-default-signed.hap
```
