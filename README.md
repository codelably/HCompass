<p align="center">
  <img alt="HCompass Logo" src="assets/images/logo.svg" width="100">
</p>

<style>
  .glow {
    background: linear-gradient(90deg, #ff6b6b, #4ecdc4, #45b7d1, #96ceb4, #f7dc6f);
    background-size: 300% 300%;
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
    animation: gradient 4s ease infinite;
    font-weight: bold;
    font-size: 2.5rem;
  }
  @keyframes gradient {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
  }
</style>

<h1 align="center" class="glow">HCompass</h1>

<p align="center">
  模块化、可复用的 HarmonyOS 快速开发框架
</p>

<p align="center">
  像搭积木一样快速构建鸿蒙应用
</p>

<p align="center">
  <a href="https://github.com/codelably/HCompass">GitHub</a> |
  <a href="https://atomgit.com/codelably/HCompass">AtomGit</a> |
  <a href="https://hcompass.codelably.com">文档</a>
</p>

---

## 介绍

HCompass 是一个基于 **HarmonyOS NEXT / ArkTS / ArkUI** 的快速开发框架，设计初衷是打造一个"模块化、可复用、开源"的开发生态。

- **模块化**：以"功能包"为核心单元，每个功能包都是一个独立的业务模块，可以单独开发、测试和复用。
- **可复用**：通过封装通用组件、工具或页面等模块，让研发人员无需深入了解细节，即可专注于上层业务的开发。
- **开源生态**：鼓励开发者贡献开源功能包，不断积累迭代通用的核心模块，形成共享生态，减少重复劳动。

## 架构设计

HCompass 采用 **四层架构** 设计，从下到上依次为：

```
┌────────────────────────────────────────────────────┐
│                  Entry / 应用入口                    │
│                 初始化框架，配置应用                    │
├────────────────────────────────────────────────────┤
│               Packages / 业务功能包层                 │
│            auth / demo / main / user ...             │
├────────────────────────────────────────────────────┤
│                Shared / 共享契约层                    │
│          contracts / state / types ...               │
├────────────────────────────────────────────────────┤
│                 Core / 框架核心层                     │
│  base / designsystem / components / database / di    │
│  navigation / network / util / ibestui ...           │
└────────────────────────────────────────────────────┘
```

| 层级 | 职责 | 说明 |
|------|------|------|
| **Entry** | 应用入口 | 初始化框架、注册功能包、配置路由、启动应用 |
| **Packages** | 业务功能包 | 独立的业务模块，通过 DI 注入实现解耦 |
| **Shared** | 共享契约 | 定义功能包之间的服务接口、共享状态和类型 |
| **Core** | 框架核心 | 与业务无关的通用能力，可直接复用到其他项目 |

功能包内部采用 **MVVM** 架构，View 层仅负责渲染，所有业务逻辑封装在 ViewModel 中。

## 核心特性

- **依赖注入（DI）**：轻量级 DI 容器，支持单例模式、子容器和类型安全，实现模块间解耦
- **导航系统**：统一的页面路由管理，支持路由注册、参数传递、路由守卫和拦截器
- **网络请求**：基于 Axios 封装的 HTTP 客户端，支持拦截器链、统一错误处理和请求配置
- **基础父类**：提供 BaseViewModel、BaseNetWorkViewModel、BaseNetWorkListViewModel 等基类，内置 loading/error/success 状态管理和分页逻辑
- **设计系统**：内置布局百分比常量、间距组件、属性扩展和增强容器组件
- **模块管理**：功能包注册和生命周期管理，支持模块初始化、服务注册和路由注册
- **数据库**：基于 IBest ORM 的本地数据库封装
- **状态管理**：使用 V2 版本 API（@ObservedV2 / AppStorageV2 / PersistenceV2）
- **UI 组件库**：集成 IBest-UI-V2，提供丰富的开箱即用 UI 组件

## 项目结构

```
HCompass/
├── entry/                  # 应用入口模块
│   └── src/main/ets/
│       ├── entryability/   # EntryAbility 初始化
│       ├── navigation/     # 导航主机
│       └── view/           # 入口页面
│
├── core/                   # 框架核心层
│   ├── base/               # 基础父类（ViewModel 基类）
│   ├── common/             # 通用模块（常量、枚举）
│   ├── components/         # 通用 UI 组件
│   ├── database/           # 数据库封装（IBest ORM）
│   ├── designsystem/       # 设计系统（颜色、间距、字体）
│   ├── di/                 # 依赖注入容器
│   ├── ibestui/            # IBest-UI-V2 组件库封装
│   ├── layoutstate/        # 布局状态管理
│   ├── module/             # 模块注册和管理
│   ├── navigation/         # 导航系统（路由配置）
│   ├── network/            # 网络请求（Axios 封装）
│   └── util/               # 工具类（Logger、ContextUtil 等）
│
├── shared/                 # 共享契约层
│   ├── contracts/          # 契约定义（服务接口）
│   ├── state/              # 共享状态
│   └── types/              # 类型定义
│
├── packages/               # 业务功能包层
│   ├── auth/               # 认证功能包
│   ├── demo/               # 示例功能包
│   ├── main/               # 主页功能包
│   └── user/               # 用户功能包
│
└── README.md               
```

## 快速开始

### 环境要求

- **DevEco Studio** 5.0 或更高版本
- **HarmonyOS SDK**：最新稳定版
- **Node.js** 18.0+

### 获取代码

```bash
git clone https://github.com/codelably/HCompass.git
cd HCompass
```

### 运行项目

1. 使用 DevEco Studio 打开项目根目录
2. 等待依赖同步完成
3. 运行 `entry` 模块进入应用

### 构建

```bash
hvigorw assembleHap -p product=default
```

## 功能包开发

每个功能包遵循标准结构：

```
packages/user/
├── navigation/             # 导航构建器
├── services/               # 服务实现
│   └── UserServiceImpl.ets
├── view/                   # 页面
│   ├── UserProfilePage.ets
│   └── UserSettingsPage.ets
├── viewmodels/             # ViewModel
│   ├── UserProfileViewModel.ets
│   └── UserSettingsViewModel.ets
├── models/                 # 数据模型（可选）
├── components/             # 组件（可选）
└── UserModule.ets          # 功能包生命周期
```

创建新功能包的步骤：

1. 在 `packages/` 目录下创建新的功能包目录
2. 在 Shared 层定义契约（如需对外提供服务）
3. 在功能包内实现业务逻辑和 Module 生命周期
4. 在 Entry 层注册功能包模块
5. 参考 `packages/demo` 获取完整示例

## 技术栈

| 技术 | 版本    | 用途 |
|------|-------|------|
| HarmonyOS NEXT | -     | 开发平台 |
| ArkTS / ArkUI | -     | 开发语言与 UI 框架 |
| @ohos/axios | 2.2.7 | HTTP 请求 |
| @ibestservices/ibest-ui-v2 | 1.1.1 | UI 组件库 |
| @ibestservices/ibest-orm | 2.0.3 | 数据库 ORM |

## 致谢

本项目的灵感来源于 [HarmonyKit](https://gitee.com/Joker-x-dev/HarmonyKit) 开源项目，感谢其作者 **Joker.X** 在鸿蒙快速开发框架方面的探索与贡献。HCompass 在其基础上进一步发展，完善了四层架构设计、依赖注入机制和高内聚、低耦合的模块化体系。

同时感谢以下开源项目的支持：

- [IBest-UI-V2](https://github.com/ibestservices/ibest-ui-v2) - 鸿蒙 UI 组件库
- [IBest-ORM](https://github.com/nicest-org/ibest-orm) - 鸿蒙数据库 ORM
- [@ohos/axios](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Faxios) - HTTP 请求库

## 参与贡献

欢迎提交 Issue 和 Pull Request 参与项目建设。

## 许可证

本项目基于 MIT 协议，请自由地享受和参与开源。
