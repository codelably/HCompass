/**
 * @file 容器接口定义
 * @description 定义依赖注入容器的核心接口
 * @author JunBin.Yang
 */

import { ServiceKey, ServiceFactory, ServiceOptions } from './ServiceProvider';

/**
 * 依赖注入容器接口
 * 提供服务注册、解析、检查等核心能力
 */
export interface Container {
  /**
   * 注册服务
   * @template T 服务类型
   * @param key 服务标识符
   * @param factory 服务工厂函数
   * @param options 注册选项
   */
  register<T>(key: ServiceKey, factory: ServiceFactory<T>, options?: ServiceOptions): void;

  /**
   * 解析服务实例
   * @template T 服务类型
   * @param key 服务标识符
   * @param default_factory 默认服务工厂函数
   * @returns 服务实例
   * @throws 服务未注册时抛出异常
   */
  resolve<T>(key: ServiceKey, default_factory?: ServiceFactory<T>): T;

  /**
   * 尝试解析服务实例
   * @template T 服务类型
   * @param key 服务标识符
   * @returns 服务实例，未注册时返回 undefined
   */
  tryResolve<T>(key: ServiceKey): T | undefined;

  /**
   * 检查服务是否已注册
   * @param key 服务标识符
   * @returns 是否已注册
   */
  has(key: ServiceKey): boolean;

  /**
   * 注销服务
   * @param key 服务标识符
   * @returns 是否注销成功
   */
  unregister(key: ServiceKey): boolean;

  /**
   * 清空所有已注册的服务
   */
  clear(): void;

  /**
   * 创建子容器
   * 子容器继承父容器的服务，但可以覆盖或新增服务
   * @returns 子容器实例
   */
  createChild(): Container;
}
