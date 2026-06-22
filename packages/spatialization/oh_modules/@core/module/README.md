# 模块注册系统 (core/module)

## 介绍

`@core/module` 模块提供功能模块的自动注册和生命周期管理，支持：

- **模块化架构**：将应用拆分为独立的功能模块
- **依赖管理**：自动解析模块依赖并按顺序初始化
- **自动注册**：自动注册服务、路由、守卫
- **生命周期管理**：统一管理模块的初始化和销毁

## 核心概念

### 功能模块 (FeatureModule)

功能模块是一个实现了 `FeatureModule` 接口的对象：

```typescript
interface FeatureModule {
  readonly moduleId: string;           // 模块唯一标识
  readonly moduleName?: string;        // 模块名称
  readonly version?: string;           // 模块版本
  readonly dependencies?: string[];    // 依赖的模块 ID

  registerServices?(container: Container): void;
  registerRoutes?(registry: RouteRegistry): void;
  registerGuards?(navigationService: NavigationService): void;
  onInit?(context: ModuleContext): Promise<void> | void;
  onDestroy?(): void;
}
```

### 模块注册器 (ModuleRegistry)

模块注册器负责管理所有功能模块的注册、依赖解析和初始化。

### 模块上下文 (ModuleContext)

```typescript
interface ModuleContext {
  container: Container;                    // DI 容器
  routeRegistry: RouteRegistry;            // 路由注册器
  navigationService?: NavigationService;  // 导航服务
}
```

## 快速开始

### 1. 创建功能模块

```typescript
import { FeatureModule, RouteRegistry, ModuleContext } from '@core/module';
import { Container } from '@core/di';
import { NavigationService, createAuthGuard } from '@core/navigation';

export class UserModule implements FeatureModule {
  readonly moduleId = 'user';
  readonly moduleName = '用户模块';
  readonly version = '1.0.0';
  readonly dependencies = ['auth'];  // 依赖 auth 模块

  registerServices(container: Container): void {
    container.register('UserService', () => new UserServiceImpl());
    container.register('UserRepository', () => new UserRepository());
  }

  registerRoutes(registry: RouteRegistry): void {
    registry.register('user/profile', wrapBuilder(ProfileNav));
    registry.register('user/settings', wrapBuilder(SettingsNav));
  }

  registerGuards(navigationService: NavigationService): void {
    navigationService.registerGuard(createAuthGuard({
      protectedRoutes: ['user/profile', 'user/settings'],
      loginRoute: 'auth/login',
      isAuthenticated: () => userState.isLoggedIn()
    }));
  }

  onInit(context: ModuleContext): void {
    console.log('User module initialized');
  }

  onDestroy(): void {
    console.log('User module destroyed');
  }
}
```

### 2. 注册和启动模块

```typescript
import { registerModules, bootstrapModules, setNavigationService } from '@core/module';
import { NavigationService } from '@core/navigation';

// 在 EntryAbility 中
onCreate(): void {
  // 注册所有模块
  registerModules([
    new AuthModule(),
    new UserModule(),
    new DemoModule()
  ]);
}

onWindowStageCreate(windowStage: window.WindowStage): void {
  // 设置导航服务
  const navService = new NavigationService(navPathStack);
  setNavigationService(navService);

  // 启动所有模块
  bootstrapModules().then(() => {
    console.log('All modules bootstrapped');
  });
}
```

## API 参考

### 全局函数

| 函数 | 说明 |
|------|------|
| `registerModule(module)` | 注册单个模块 |
| `registerModules(modules)` | 批量注册模块 |
| `bootstrapModules()` | 启动所有模块 |
| `getModuleState(moduleId)` | 获取模块状态 |
| `setNavigationService(navService)` | 设置导航服务 |
| `destroyModules()` | 销毁所有模块 |
| `resetModuleRegistry()` | 重置模块注册器 |
| `getModuleRegistry()` | 获取全局模块注册器 |

### ModuleRegistry

| 方法 | 说明 |
|------|------|
| `register(module)` | 注册模块 |
| `registerAll(modules)` | 批量注册模块 |
| `bootstrap()` | 启动所有模块 |
| `getModuleState(moduleId)` | 获取模块状态 |
| `getModuleIds()` | 获取所有模块 ID |
| `isBootstrapped()` | 是否已启动 |
| `setNavigationService(navService)` | 设置导航服务 |
| `destroy()` | 销毁所有模块 |

### ModuleState

```typescript
enum ModuleState {
  REGISTERED = 'registered',     // 已注册
  INITIALIZING = 'initializing', // 正在初始化
  INITIALIZED = 'initialized',   // 已初始化
  FAILED = 'failed'              // 初始化失败
}
```

## 模块依赖

模块可以声明依赖其他模块，系统会自动按依赖顺序初始化：

```typescript
export class OrderModule implements FeatureModule {
  readonly moduleId = 'order';
  readonly dependencies = ['auth', 'user', 'product'];  // 依赖这些模块

  // ...
}
```

依赖解析规则：
1. 被依赖的模块先初始化
2. 循环依赖会抛出错误
3. 缺失的依赖会打印警告但不阻止初始化

## 继承 BaseModule

```typescript
import { BaseModule, RouteRegistry } from '@core/module';
import { Container } from '@core/di';

export class ProductModule extends BaseModule {
  readonly moduleId = 'product';
  readonly moduleName = '商品模块';
  readonly dependencies = ['auth'];

  registerServices(container: Container): void {
    container.register('ProductService', () => new ProductServiceImpl());
  }

  registerRoutes(registry: RouteRegistry): void {
    registry.register('product/list', wrapBuilder(ProductListNav));
    registry.register('product/detail', wrapBuilder(ProductDetailNav));
  }
}
```

## 完整示例

### 应用入口配置

```typescript
// entry/src/main/ets/entryability/EntryAbility.ets
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import {
  registerModules,
  bootstrapModules,
  setNavigationService,
  destroyModules
} from '@core/module';
import { NavigationService } from '@core/navigation';
import { AuthModule } from '@package/auth';
import { UserModule } from '@package/user';
import { ProductModule } from '@package/product';

export default class EntryAbility extends UIAbility {
  private navService?: NavigationService;

  onCreate(): void {
    // 注册所有功能模块
    registerModules([
      new AuthModule(),
      new UserModule(),
      new ProductModule()
    ]);
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    windowStage.loadContent('view/EntryPage', async () => {
      // 创建导航服务
      this.navService = new NavigationService(navPathStack);
      setNavigationService(this.navService);

      // 启动所有模块
      await bootstrapModules();
    });
  }

  onDestroy(): void {
    // 销毁所有模块
    destroyModules();
  }
}
```

### 功能包结构

```
packages/
├── package-auth/
│   ├── src/
│   │   ├── AuthModule.ts      # 模块定义
│   │   ├── services/          # 服务实现
│   │   ├── views/             # 页面视图
│   │   └── navigation/        # 路由定义
│   └── oh-package.json5
│
├── package-user/
│   ├── src/
│   │   ├── UserModule.ts
│   │   └── ...
│   └── oh-package.json5
│
└── package-product/
    ├── src/
    │   ├── ProductModule.ts
    │   └── ...
    └── oh-package.json5
```

## 最佳实践

### 1. 模块职责单一

每个模块只负责一个业务域：
- `auth` - 认证相关
- `user` - 用户相关
- `product` - 商品相关
- `order` - 订单相关

### 2. 合理声明依赖

只声明直接依赖，不要声明传递依赖：
```typescript
// 好
readonly dependencies = ['auth'];

// 避免（如果 auth 已经依赖 core）
readonly dependencies = ['auth', 'core'];
```

### 3. 在 onInit 中做初始化

```typescript
async onInit(context: ModuleContext): Promise<void> {
  // 加载配置
  await this.loadConfig();

  // 初始化缓存
  this.initCache();

  // 预加载数据
  await this.preloadData();
}
```

## 文件结构

```
core/module/
├── Index.ets                      # 模块导出
├── oh-package.json5               # 包配置
├── hvigorfile.ts                  # 构建配置
├── BuildProfile.ets               # 构建配置
└── src/main/
    ├── module.json5               # 模块配置
    └── ets/
        ├── FeatureModule.ets      # 模块接口定义
        ├── ModuleRegistry.ets     # 模块注册器
        ├── GlobalModuleRegistry.ets # 全局注册器
        └── BaseModule.ets         # 模块基类
```
