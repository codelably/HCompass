# Database Module

数据库模块，集成 IBestORM 提供轻量级的对象关系映射（ORM）能力。

## 介绍

database 模块是对 `@ibestservices/ibest-orm` 的封装和导出，提供统一的数据库访问接口。IBestORM 是一个轻量级的 ORM 框架，专为 HarmonyOS 设计。

## 功能特性

- **实体映射**: 使用装饰器定义数据库表和字段
- **CRUD 操作**: 提供完整的增删改查 API
- **关系映射**: 支持一对一、一对多、多对多关系
- **查询构建器**: 链式 API 构建复杂查询
- **事务支持**: 支持数据库事务操作
- **迁移管理**: 数据库版本管理和迁移

## 使用场景

- **本地数据缓存**: 缓存网络请求的数据
- **离线功能**: 实现应用的离线访问能力
- **用户数据存储**: 存储用户配置、历史记录等
- **复杂数据关系**: 处理具有关联关系的数据模型

## 注意事项

1. **初始化时机**: 必须在使用数据库前完成初始化
2. **上下文依赖**: 需要先初始化 ContextUtil
3. **实体注册**: 所有实体类必须在 createConnection 时注册

## 更多信息

IBestORM 的详细文档和 API 参考，请访问：
- GitHub: https://github.com/ibestservices/ibest-orm
- 官方文档: [IBestORM Documentation]

## 依赖关系

- **@ibestservices/ibest-orm**: IBestORM 核心库
- **@core/util**: 使用 ContextUtil 获取上下文
