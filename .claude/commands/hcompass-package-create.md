---
name: hcompass-package-create
description: "在 HCompass 框架中创建新功能包（Package）的完整向导。从目录结构、配置文件到 Module 文件编写、Entry 注册，一步到位生成标准功能包骨架。触发场景：需要新增业务功能包时。"
---

# 创建 HCompass 功能包

## 创建前确认

1. **包名**：`packages/` 下的目录名，如 `order`
2. **模块ID**：唯一字符串，如 `'order'`
3. **是否需要对外服务**（跨包调用）：是 → 需要在 `shared/contracts` 定义契约
4. **依赖哪些已有包**：如 `['auth']`（auth 必须先初始化）

## 第一步：创建目录结构

```
packages/<name>/
├── src/
│   └── main/
│       └── ets/
│           ├── components/         # 包内私有组件（按需创建）
│           ├── models/             # 包内数据模型（按需创建）
│           ├── navigation/         # 路由构建器
│           │   └── <Name>PageNav.ets
│           ├── services/           # 服务实现
│           │   ├── <Name>ServiceImpl.ets
│           │   └── datasource/
│           │       ├── <Name>NetworkDataSource.ets
│           │       └── <Name>LocalDataSource.ets
│           ├── view/               # 页面（仅渲染）
│           │   └── <Name>Page.ets
│           ├── viewmodels/         # ViewModel
│           │   └── <Name>ViewModel.ets
│           └── <Name>Module.ets    # 模块生命周期入口
├── src/main/module.json5
├── build-profile.json5
├── hvigorfile.ts
├── Index.ets
└── oh-package.json5
```

## 第二步：配置文件

### oh-package.json5
```json5
{
  "name": "@package/<name>",
  "version": "1.0.0",
  "description": "<功能描述>",
  "main": "Index.ets",
  "author": "",
  "license": "Apache-2.0",
  "dependencies": {
    "@core/base": "file:../../core/base",
    "@core/components": "file:../../core/components",
    "@core/di": "file:../../core/di",
    "@core/navigation": "file:../../core/navigation",
    "@shared/contracts": "file:../../shared/contracts"
  }
}
```

### build-profile.json5
```json5
{
  "apiType": "stageMode",
  "targets": [{ "name": "default" }]
}
```

### src/main/module.json5
```json5
{
  "module": {
    "name": "<name>",
    "type": "har",
    "deviceTypes": ["default", "tablet", "2in1"]
  }
}
```

### hvigorfile.ts
```typescript
export { harTasks } from '@ohos/hvigor-ohos-plugin';
```

## 第三步：创建 Module 文件

`src/main/ets/<Name>Module.ets`：
```typescript
/**
 * @file <Name>功能包模块生命周期
 * @author JunBin.Yang
 */
import { Container, FeatureModule, ModuleContext, RouteRegistry } from "@core/module";
import { NavigationService } from "@core/navigation";
import { <NAME>_SVC_KEY, I<Name>Service } from "@shared/contracts";  // 如需对外服务
import { <Name>Routes } from "@shared/contracts";
import { <Name>ServiceImpl } from "./services/<Name>ServiceImpl";
import { <name>PageNavBuilderWrapper } from "./navigation/<Name>PageNav";

export class <Name>Module implements FeatureModule {
  readonly moduleId: string = "<name>";
  readonly moduleName: string = "<功能名>";
  readonly version: string = "1.0.0";
  readonly dependencies: string[] = [];  // 填写依赖的模块ID

  registerServices(container: Container): void {
    container.register<<I<Name>Service>>(<NAME>_SVC_KEY, () => new <Name>ServiceImpl());
  }

  registerRoutes(registry: RouteRegistry): void {
    registry.register(<Name>Routes.Main, <name>PageNavBuilderWrapper);
  }

  registerGuards(navigationService: NavigationService): void {
    // 按需添加路由守卫
  }

  async onInit(context: ModuleContext): Promise<void> {
    // 模块初始化逻辑
  }

  onDestroy(): void {
    // 资源清理
  }
}

export function create<Name>Module(): <Name>Module {
  return new <Name>Module();
}
```

## 第四步：Index.ets 导出

```typescript
export { <Name>Module, create<Name>Module } from "./src/main/ets/<Name>Module";
// 按需导出其他公共类型
```

## 第五步：在根 build-profile.json5 注册模块

在项目根目录 `build-profile.json5` 的 `modules` 数组中添加：
```json5
{ "name": "<name>", "srcPath": "./packages/<name>" }
```

## 第六步：在 Entry 层注册

`entry/src/main/ets/entryability/EntryAbility.ets` 中：
```typescript
import { create<Name>Module } from "@package/<name>";

// 在 InitializerFramework 方法的模块注册处添加：
registry.register(create<Name>Module());
```

同时在 `entry/oh-package.json5` 中添加依赖：
```json5
"@package/<name>": "file:../../packages/<name>"
```

## 第七步：验证

执行构建确认无误：
```bash
hvigorw assembleHap -p product=default
```

如构建失败，使用 `/hcompass-build-fix` 定位问题。
