---
name: hcompass-code-review
description: "HCompass 框架专属代码审查。逐项检查 V2 状态管理合规性、MVVM 分层、布局约束、DI 规范、不可变性、类型注解、代码风格。输出分级问题报告（CRITICAL/HIGH/MEDIUM/LOW）。触发场景：编写或修改代码后，提交前审查。"
---

# HCompass 代码审查

## 使用方式

提供需要审查的文件路径或代码片段，逐项对照以下检查清单输出问题报告。

## 检查清单

### CRITICAL（必须修复，阻止合并）

**V2 状态管理违规**
- [ ] `@Component` 未迁移到 `@ComponentV2`
- [ ] V2 组件中使用 V1 装饰器：`@State/@Prop/@Link/@Observed/@ObjectLink/@Provide/@Consume`
- [ ] `@ObservedV2` 类中属性缺少 `@Trace`（会导致 UI 不更新）
- [ ] `@Param` 属性被直接赋值（V2 只读）
- [ ] 使用了 `AppStorage`（应改为 `AppStorageV2`）

**MVVM 分层违规**
- [ ] View/Page 中存在网络请求（`http.createHttp`/`HttpClient`）
- [ ] View/Page 中存在业务逻辑（数据计算/处理/转换）
- [ ] View 直接 import Model 层文件（应通过 ViewModel 访问）
- [ ] ViewModel 中存在 UI 组件引用

**不可变性违规**
- [ ] 直接修改数组：`this.list.push()` / `this.list.splice()` / `this.list[i] = ...`
- [ ] 直接修改对象属性：`this.userInfo.name = ...`

**安全规范**
- [ ] 硬编码密钥/Token/密码
- [ ] 使用 `any` 类型（ArkTS 禁止）

---

### HIGH（应修复）

**DI 规范违规**
- [ ] 在 Module.registerServices 以外的地方 `new` Service 实例（绕过 DI 容器）
- [ ] 在 View/Page 层调用 `getContainer().resolve()`（应在 ViewModel 构造函数中注入）
- [ ] Service 未通过接口（shared/contracts）定义直接被 ViewModel 依赖

**布局约束违规**
- [ ] 均分布局使用 `FlexAlign.SpaceAround` 或 `SpaceBetween`（应用 `layoutWeight(1)`）
- [ ] 宽高硬编码非图标元素：`.width(375)` / `.height(800)` 等
- [ ] 未使用 `core/designsystem` 提供的容器组件（`RowBase/ColumnBase` 等）

**组件选用违规**
- [ ] 重复开发了 IBest-UI-V2 或 `core/components` 中已有的组件
- [ ] 直接使用 `Row/Column` 替代 `RowBase/ColumnBase`（框架容器组件）

---

### MEDIUM（建议修复）

**代码规范**
- [ ] 文件头缺少 `@file` 描述或 `@author JunBin.Yang`
- [ ] 方法缺少 JSDoc 注释（`@param`/`@returns`）
- [ ] 变量命名不符合规范（变量/函数 camelCase，类 PascalCase，常量 UPPER_SNAKE_CASE）
- [ ] 字符串使用单引号（应使用双引号）
- [ ] 语句末尾缺少分号

**文件大小**
- [ ] 单文件超过 800 行（应拆分）
- [ ] 方法超过 50 行（应拆分）
- [ ] 嵌套超过 4 层（应重构）

**状态管理**
- [ ] 全局状态（`AppStorageV2`）存放了只有一个模块使用的状态（应移到包内 ViewModel）
- [ ] ViewModel 中派生属性用 `@Trace` 存储（应改用 `get` 计算属性）

---

### LOW（可选优化）

- [ ] 遗留 `console.log` 调试语句
- [ ] 注释语言混用（应以中文为主，技术关键词保留英文）
- [ ] 导入顺序不规范（建议：kit 导入 → core 导入 → shared 导入 → 本包导入）

---

## 输出格式

```
## 审查结果：<文件路径>

### CRITICAL
- [文件:行号] <问题描述>
  修复建议：<具体改法>

### HIGH
- [文件:行号] <问题描述>
  修复建议：<具体改法>

### MEDIUM
- [文件:行号] <问题描述>

### 总结
CRITICAL: X 项 | HIGH: X 项 | MEDIUM: X 项 | LOW: X 项
结论：[通过 / 需要修复后合并 / 阻止合并]
```

## 审查判定标准

| 结论 | 条件 |
|------|------|
| 通过 | 无 CRITICAL 和 HIGH 问题 |
| 需修复后合并 | 有 HIGH 问题，无 CRITICAL |
| 阻止合并 | 存在任何 CRITICAL 问题 |
