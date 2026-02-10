# Common Module

通用类型和工具模块，提供跨模块使用的基础类型定义、模型类和工具函数。

## 功能特性

### 类型别名

提供常用的类型别名，统一项目中的类型使用：

- **Any**: `any` 类型的别名
- **Unknown**: `unknown` 类型的别名
- **Symbol**: `symbol` 类型的别名

### 模型类

#### Id

用于处理只返回单个ID的接口响应。

```typescript
import { Id } from '@core/common';

const result = new Id(123);
console.log(result.id); // 123
```

#### Ids

用于处理返回ID数组的接口响应。

```typescript
import { Ids } from '@core/common';

const result = new Ids([1, 2, 3]);
console.log(result.ids); // [1, 2, 3]
```

### 工具函数

#### ObjectAssign

深度合并多个对象，支持递归合并嵌套对象。

```typescript
import { ObjectAssign } from '@core/common';

const target = { a: 1, b: { c: 2 } };
const source = { b: { d: 3 }, e: 4 };

const result = ObjectAssign(target, source);
// result: { a: 1, b: { c: 2, d: 3 }, e: 4 }
```

**特性：**
- 递归合并嵌套对象
- 数组直接覆盖，不合并
- 自动处理 null 和 undefined
- 类型安全的泛型支持

#### SymbolToString

将 Symbol 类型转换为字符串。

```typescript
import { SymbolToString } from '@core/common';

const sym = Symbol('test');
const str = SymbolToString(sym);
console.log(str); // "Symbol(test)"
```

## 使用场景

- **类型别名**: 统一项目中的类型使用，提高代码可读性
- **Id/Ids 模型**: 处理后端返回的ID响应，避免直接使用 number 或 number[]
- **ObjectAssign**: 配置合并、默认值设置、对象深拷贝等场景
- **SymbolToString**: Symbol 类型的调试和日志输出

## 导入方式

```typescript
import { Any, Unknown, Symbol, Id, Ids, ObjectAssign, SymbolToString } from '@core/common';
```
