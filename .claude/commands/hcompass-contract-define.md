---
name: hcompass-contract-define
description: "在 HCompass shared/contracts 层定义跨包服务契约。包括服务接口、DI Key 常量、路由常量的创建，以及 Index.ets 导出。触发场景：新建功能包需要对外提供服务或被其他包调用路由时。"
---

# 定义跨包契约

共享契约层（`shared/contracts`）是功能包之间通信的唯一桥梁，只定义接口和常量，不含任何实现。

## 契约文件位置

```
shared/contracts/src/main/ets/
├── services/
│   └── I<Name>Service.ets      # 服务接口 + DI Key
├── routes/
│   └── <Name>Routes.ets        # 路由常量
└── types/                       # 跨包共用类型（按需）
    └── <Name>Types.ets
```

## 第一步：定义服务接口

`shared/contracts/src/main/ets/services/I<Name>Service.ets`：
```typescript
/**
 * @file <Name>服务契约
 * @author JunBin.Yang
 */

/** DI 注册键，全局唯一，避免重名 */
export const <NAME>_SVC_KEY: string = "<name>Service";

/** <Name>服务接口 */
export interface I<Name>Service {
  /**
   * 示例方法
   * @param id 资源ID
   * @returns 操作结果
   */
  getData(id: string): Promise<<Name>Data>;
}

/** 数据类型（如跨包使用则定义在契约层） */
export interface <Name>Data {
  id: string;
  // ...其他字段
}
```

## 第二步：定义路由常量

`shared/contracts/src/main/ets/routes/<Name>Routes.ets`：
```typescript
/**
 * @file <Name>包路由常量
 * @author JunBin.Yang
 */
export class <Name>Routes {
  static readonly Main: string = "<name>/main";
  static readonly Detail: string = "<name>/detail";
  // 格式：模块名/页面名（小写）
}
```

## 第三步：在 shared/contracts/Index.ets 中导出

打开 `shared/contracts/Index.ets`，追加导出：
```typescript
// <Name> 模块契约
export { <NAME>_SVC_KEY, I<Name>Service } from "./src/main/ets/services/I<Name>Service";
export type { <Name>Data } from "./src/main/ets/services/I<Name>Service";
export { <Name>Routes } from "./src/main/ets/routes/<Name>Routes";
```

## 使用方

### 服务提供方（在功能包 Module 中注册）
```typescript
import { <NAME>_SVC_KEY, I<Name>Service } from "@shared/contracts";
import { <Name>ServiceImpl } from "./services/<Name>ServiceImpl";

// 在 registerServices 中：
container.register<I<Name>Service>(<NAME>_SVC_KEY, () => new <Name>ServiceImpl());
```

### 服务消费方（在 ViewModel 中注入）
```typescript
import { <NAME>_SVC_KEY, I<Name>Service } from "@shared/contracts";
import { getContainer } from "@core/di";

// 在 ViewModel 构造函数中：
this.<name>Service = getContainer().resolve<I<Name>Service>(<NAME>_SVC_KEY);
```

### 路由调用方（在任意 ViewModel 中）
```typescript
import { <Name>Routes } from "@shared/contracts";
import { NavigationService } from "@core/navigation";

// 跳转到目标页：
navigationService.navigateTo(<Name>Routes.Main, params);
```

## 注意事项

- 契约层只允许定义 `interface`、`class`（纯数据）、`const`，禁止任何业务实现代码
- DI Key 必须全项目唯一，建议用 `模块名+Service` 格式命名
- 路由路径格式统一为 `模块名/页面名`（全小写）
- 新增契约后必须在 `Index.ets` 导出，否则其他模块无法引用
