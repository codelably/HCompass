---
name: hcompass-statemgt-v2
description: "HCompass 框架状态管理 V2 规范，以及 V1 → V2 迁移指南。涵盖装饰器迁移映射、应用级状态（AppStorageV2/PersistenceV2）、跨包共享状态（shared/state）、不可变性操作规范。触发场景：V1 项目升级 V2，或不确定 V2 用法时。"
---

# HCompass 状态管理 V2

## 框架强制规范

HCompass **禁止所有 V1 状态管理 API**，全面使用 V2。

## V1 → V2 装饰器映射

### 组件装饰器

| V1 | V2 | 说明 |
|----|----|----|
| `@Component` | `@ComponentV2` | 组件声明 |
| `@State` | `@Local` | 组件内部状态，禁止外部初始化 |
| `@Prop` | `@Param` | 父→子单向，V2 中只读 |
| `@Link` | `@Param` + `@Event` | 双向同步需手动实现 |
| `@Observed` | `@ObservedV2` | 可观察类 |
| `@ObjectLink` + `@Track` | `@ObservedV2` + `@Trace` | 深度属性观测 |
| `@Provide/@Consume` | `@Provider/@Consumer` | 跨组件共享 |
| `@Watch` | `@Monitor` | 状态变化监听 |
| `@Reusable` | `@ReusableV2` | 组件复用 |
| `ForEach` | `Repeat` | 循环渲染 |
| `LazyForEach` | `Repeat + .virtualScroll()` | 懒加载循环 |
| `$$` | `!!` | 双向绑定语法糖 |

### 应用级状态

| V1 | V2 |
|----|----|
| `AppStorage.setOrCreate(key, val)` | `AppStorageV2.getOrCreate(MyClass, key, val)` |
| `@StorageLink` | `AppStorageV2.connect()` + `@Local` |
| `PersistentStorage` | `PersistenceV2` |
| `LocalStorage` | `@ObservedV2` 单例 |

## HCompass 跨包共享状态

跨功能包共享状态放在 `shared/state/`，使用 `AppStorageV2`：

```typescript
// shared/state/src/main/ets/DemoCounterState.ets
@ObservedV2
export class DemoCounterState {
  @Trace count: number = 0;

  static instance(): DemoCounterState {
    return AppStorageV2.getOrCreate(DemoCounterState, "demoCounter", new DemoCounterState());
  }
}
```

在 ViewModel 中使用：
```typescript
// 获取共享状态实例
private counterState: DemoCounterState = DemoCounterState.instance();

increment(): void {
  // 不可变更新
  this.counterState.count = this.counterState.count + 1;
}
```

## 持久化存储

```typescript
// 初始化（在 EntryAbility 中）
PersistenceV2.connect(UserSettings, "userSettings", new UserSettings());

// 读写
const settings = PersistenceV2.connect(UserSettings, "userSettings") as UserSettings;
settings.theme = "dark";  // 自动持久化
```

## V2 关键差异

### 观测深度

```typescript
// V1：@State 自动观测第一层属性
@State user: User = new User();  // user.name 变化会触发更新

// V2：@Local 只观测引用本身，深度观测需 @ObservedV2 + @Trace
@ObservedV2
class User {
  @Trace name: string = "";  // 必须加 @Trace 才能被观测
}
@Local user: User = new User();
```

### @Param 只读

```typescript
// V2：@Param 是只读的
@Param title: string = "";
// this.title = "新标题";  // 编译错误！

// 需要修改：通过 @Event 回调
@Event onTitleChange: (title: string) => void = () => {};
// 父组件传入回调，子组件触发
```

### @Provider/@Consumer 必须有初始值

```typescript
@Consumer("navPathStack") navPathStack: NavPathStack = new NavPathStack();
// 或使用 @Require 明确要求父组件提供
@Require @Consumer("navPathStack") navPathStack: NavPathStack;
```

## 迁移步骤

1. 扫描 V1 装饰器：
```bash
grep -r "@Component\b\|@State\|@Prop\b\|@Link\|@Observed\b\|@ObjectLink\|@Provide\|@Consume\|@Watch\|@Reusable\b\|@StorageLink\|@StorageProp\|AppStorage\." packages/ --include="*.ets" -l
```

2. 按"叶子组件优先"原则，从最底层组件向上逐一迁移

3. 每迁移一个文件后运行 `/hcompass-syntax-checker` 验证

## 迁移检查清单

- [ ] `@Component` → `@ComponentV2`
- [ ] `@State` → `@Local`（外部初始化的改为 `@Param @Once`）
- [ ] `@Prop` → `@Param`
- [ ] `@Link` → `@Param` + `@Event`
- [ ] `@Observed` → `@ObservedV2`
- [ ] `@ObjectLink` + `@Track` → `@ObservedV2` 类 + `@Trace` 属性
- [ ] `@Provide/@Consume` → `@Provider/@Consumer`（加初始值）
- [ ] `@Watch` → `@Monitor`
- [ ] `@Reusable` → `@ReusableV2`
- [ ] `AppStorage` → `AppStorageV2`
- [ ] `PersistentStorage` → `PersistenceV2`
- [ ] `ForEach` → `Repeat`
- [ ] `LazyForEach` → `Repeat + .virtualScroll()`
- [ ] `$$` → `!!`
