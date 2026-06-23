---
name: hcompass-build-fix
description: "修复 HCompass 项目构建失败问题。针对框架多模块结构优先排查：模块依赖路径配置、Index.ets 导出遗漏、V2 装饰器错误、模块注册问题。触发场景：hvigorw 构建失败或 DevEco Studio 报红时。"
---

# HCompass 构建错误修复

## 构建命令

```bash
hvigorw assembleHap -p product=default
```

## 错误类型速查

### 1. 模块找不到（Cannot find module）

**错误特征**：`Cannot find module '@core/xxx'` 或 `Cannot find module '@package/xxx'`

**排查步骤**：

1. 检查报错模块的 `oh-package.json5` 是否声明依赖：
```json5
// 路径格式：file:../../<层级>/<模块名>
"@core/base": "file:../../core/base",
"@package/auth": "file:../../packages/auth"
```

2. 检查根目录 `build-profile.json5` 的 `modules` 数组是否包含该模块：
```json5
{ "name": "auth", "srcPath": "./packages/auth" }
```

3. 检查被依赖模块的 `Index.ets` 是否导出了目标类/函数。

---

### 2. 未导出符号（is not exported）

**错误特征**：`'Xxx' is not exported from '@core/xxx'`

**修复**：打开被依赖模块的 `Index.ets`，添加导出：
```typescript
export { MyClass } from "./src/main/ets/MyClass";
export type { MyInterface } from "./src/main/ets/types/MyInterface";
```

---

### 3. V2 装饰器错误

| 错误信息 | 修复方案 |
|---------|---------|
| `@State cannot be used in @ComponentV2` | 改为 `@Local` |
| `Property is not traceable` | 给 `@ObservedV2` 类的属性加 `@Trace` |
| `@Param property cannot be assigned` | 通过 `@Event` 回调修改，或改用 `@Local` |
| `AppStorage is deprecated in V2` | 改为 `AppStorageV2.getOrCreate(...)` |
| `@Observed cannot be used with @Trace` | 类装饰器改为 `@ObservedV2` |

---

### 4. ArkTS 编译器错误（10505001）

**错误特征**：`This expression is not callable. Not all constituents of type 'CustomBuilder' are callable.`

**原因**：`CustomBuilder` 类型既包含函数类型也包含 `void`，直接调用时类型系统报错。

**修复**：使用 `wrapBuilder` 包装 `@Builder` 函数，或先做类型收窄：
```typescript
// 错误写法
@BuilderParam contentBuilder: CustomBuilder;
this.contentBuilder()  // 报错

// 正确写法1：明确类型
@BuilderParam contentBuilder: () => void;
this.contentBuilder()

// 正确写法2：wrapBuilder
const builder: WrappedBuilder<[]> = wrapBuilder(myBuilder);
```

---

### 5. 模块初始化失败（循环依赖）

**错误特征**：`Circular dependency detected between modules: A -> B -> A`

**修复**：
1. 检查 `<Name>Module.dependencies` 数组中的依赖声明
2. 提取循环依赖部分到独立模块，或将共享接口移至 `shared/contracts`

---

### 6. class constructor cannot be called without 'new'

**错误特征**：应用启动时报 `class constructor cannot called without 'new'`

**原因**：`@ObservedV2` 装饰类在某些场景被当作普通函数调用。

**修复**：检查 `@ComponentV2` 中 ViewModel 的初始化方式：
```typescript
// 错误
@Local viewModel = <Name>ViewModel;  // 遗漏 new

// 正确
@Local viewModel: <Name>ViewModel = new <Name>ViewModel();
```

---

### 7. 资源找不到（Resource not found）

**错误特征**：`Resource 'app.string.xxx' not found`

**修复**：检查对应模块的 `src/main/resources/base/element/string.json` 文件是否包含该资源键。多语言资源需同步在 `en/element/string.json` 中添加。

---

## 通用排查流程

```
1. 读取完整错误日志（重点看第一条 ERROR，后续往往是级联错误）
2. 识别错误类型（对照上方速查表）
3. 定位文件（错误信息中会有文件路径和行号）
4. 修复后重新构建
5. 仍失败 → 使用 /hcompass-syntax-checker 进行静态检查
```
