# HCompass AI 辅助开发 Skills 使用指南

本项目配置了12个 HCompass 框架专属 Skill，与 Claude Code 配合使用，覆盖功能包开发的完整工作流。

## Skill 总览

### 开发流程类

| Skill | 触发方式 | 用途 |
|---|---|---|
| 创建功能包 | `/hcompass-package-create` | 生成完整功能包骨架（目录/配置/Module/Entry注册） |
| 定义跨包契约 | `/hcompass-contract-define` | 在 shared/contracts 创建服务接口、DI Key、路由常量 |
| 创建 ViewModel | `/hcompass-viewmodel-create` | 三种基类选择决策 + @ObservedV2/@Trace + DI注入 |
| 注册路由 | `/hcompass-navigation-register` | WrappedBuilder + registerRoutes + RouteGuard 守卫 |
| 实现网络服务 | `/hcompass-network-service` | DataSource 分层 + ServiceImpl + NetworkResult |
| DI 容器 | `/hcompass-di-register` | register/resolve/tryResolve 用法 |
| UI 开发 | `/hcompass-ui-develop` | View 层编写（组件优先级 + 布局约束） |

### 架构规范类

| Skill | 触发方式 | 用途 |
|---|---|---|
| MVVM 向导 | `/hcompass-mvvm-pattern` | 新建/整改 MVVM 分层，状态变量归属决策 |
| V2 状态管理 | `/hcompass-statemgt-v2` | V1→V2 迁移映射表 + AppStorageV2 规范 |

### 质量保障类

| Skill | 触发方式 | 用途 |
|---|---|---|
| 构建检查 | `/hcompass-syntax-checker` | 静态检查 + hvigorw 构建，最多5轮自动循环 |
| 构建修复 | `/hcompass-build-fix` | 多模块依赖路径/导出遗漏/V2装饰器错误速查 |
| 代码审查 | `/hcompass-code-review` | CRITICAL/HIGH/MEDIUM/LOW 分级问题报告 |

---

## 推荐工作流

### 场景一：开发新功能包（全新业务模块）

```
1. /hcompass-package-create        创建包骨架
2. /hcompass-contract-define       定义跨包契约（需对外服务/路由时）
3. /hcompass-network-service       实现网络服务（有网络请求时）
4. /hcompass-viewmodel-create      创建 ViewModel
5. /hcompass-navigation-register   注册路由和守卫
6. /hcompass-ui-develop            编写 View 层
7. /hcompass-syntax-checker        构建验证
8. /hcompass-code-review           提交前代码审查
```

### 场景二：在已有功能包中新增页面/功能

```
1. /hcompass-contract-define       补充契约（需新增对外接口时）
2. /hcompass-network-service       补充网络接口（有新接口时）
3. /hcompass-viewmodel-create      创建新 ViewModel
4. /hcompass-navigation-register   注册新路由（有新页面时）
5. /hcompass-ui-develop            编写 View 层
6. /hcompass-syntax-checker        构建验证
7. /hcompass-code-review           提交前代码审查
```

### 场景三：整改/重构已有代码（MVVM/V2 合规性改造）

```
1. /hcompass-code-review           审查现有代码，找出问题
2. /hcompass-statemgt-v2           迁移 V1 → V2 状态管理
3. /hcompass-mvvm-pattern          按框架规范重新分层
4. /hcompass-syntax-checker        验证构建
5. /hcompass-code-review           复审确认
```

### 场景四：排查构建/运行问题

```
- 构建失败            → /hcompass-build-fix
- 编译错误反复出现    → /hcompass-syntax-checker（静态检查循环）
- V2 相关错误         → /hcompass-statemgt-v2
```

---

## Skill 文件位置

所有 Skill 文件存放在 `.claude/commands/` 目录下，可直接查阅或修改：

```
.claude/commands/
├── hcompass-package-create.md
├── hcompass-contract-define.md
├── hcompass-viewmodel-create.md
├── hcompass-navigation-register.md
├── hcompass-network-service.md
├── hcompass-di-register.md
├── hcompass-ui-develop.md
├── hcompass-mvvm-pattern.md
├── hcompass-statemgt-v2.md
├── hcompass-syntax-checker.md
├── hcompass-build-fix.md
└── hcompass-code-review.md
```
