/**
 * @file 服务容器实现
 * @description 依赖注入容器的核心实现
 * @author JunBin.Yang
 */

import { Unknown, SymbolToString } from "@core/common";
import { Container } from './Container';
import { ServiceKey, ServiceFactory, ServiceDescriptor, ServiceOptions } from './ServiceProvider';

/**
 * 服务容器实现类
 * 提供依赖注入的核心功能
 */
export class ServiceContainer implements Container {
  /**
   * 服务注册表
   */
  private services: Map<ServiceKey, ServiceDescriptor<Unknown>> = new Map();

  /**
   * 父容器引用（用于子容器）
   */
  private parent?: ServiceContainer;

  /**
   * 构造函数
   * @param parent 父容器（可选）
   */
  constructor(parent?: ServiceContainer) {
    this.parent = parent;
  }

  /**
   * 注册服务
   * @template T 服务类型
   * @param key 服务标识符
   * @param factory 服务工厂函数
   * @param options 注册选项
   */
  register<T>(key: ServiceKey, factory: ServiceFactory<T>, options?: ServiceOptions): void {
    const singleton = options?.singleton !== false; // 默认为单例
    const descriptor: ServiceDescriptor<T> = {
      factory,
      singleton,
      instance: undefined
    };
    this.services.set(key, descriptor as ServiceDescriptor<Unknown>);
  }

  /**
   * 解析服务实例
   * @template T 服务类型
   * @param key 服务标识符
   * @param default_factory 默认服务工厂函数
   * @returns 服务实例
   * @throws 服务未注册时抛出异常
   */
  resolve<T>(key: ServiceKey, default_factory?: ServiceFactory<T>): T {
    const instance = this.tryResolve<T>(key);
    if (instance !== undefined) {
      return instance;
    }

    if (default_factory === undefined) {
      const keyStr = typeof key === 'symbol' ? SymbolToString(key) : key;
      throw new Error(`[ServiceContainer] Service not registered: ${keyStr}`);
    }

    this.register(key, default_factory);
    return this.resolve<T>(key);
  }

  /**
   * 尝试解析服务实例
   * @template T 服务类型
   * @param key 服务标识符
   * @returns 服务实例，未注册时返回 undefined
   */
  tryResolve<T>(key: ServiceKey): T | undefined {
    // 先从当前容器查找
    const descriptor = this.services.get(key) as ServiceDescriptor<T> | undefined;

    if (descriptor) {
      return this.getInstance<T>(descriptor);
    }

    // 从父容器查找
    if (this.parent) {
      return this.parent.tryResolve<T>(key);
    }

    return undefined;
  }

  /**
   * 获取服务实例
   * @template T 服务类型
   * @param descriptor 服务描述符
   * @returns 服务实例
   */
  private getInstance<T>(descriptor: ServiceDescriptor<T>): T {
    if (descriptor.singleton) {
      // 单例模式：缓存实例
      if (descriptor.instance === undefined) {
        descriptor.instance = descriptor.factory();
      }
      return descriptor.instance;
    }
    // 非单例模式：每次创建新实例
    return descriptor.factory();
  }

  /**
   * 检查服务是否已注册
   * @param key 服务标识符
   * @returns 是否已注册
   */
  has(key: ServiceKey): boolean {
    if (this.services.has(key)) {
      return true;
    }
    if (this.parent) {
      return this.parent.has(key);
    }
    return false;
  }

  /**
   * 注销服务
   * @param key 服务标识符
   * @returns 是否注销成功
   */
  unregister(key: ServiceKey): boolean {
    return this.services.delete(key);
  }

  /**
   * 清空所有已注册的服务
   */
  clear(): void {
    this.services.clear();
  }

  /**
   * 创建子容器
   * @returns 子容器实例
   */
  createChild(): Container {
    return new ServiceContainer(this);
  }

  /**
   * 获取已注册的服务数量
   * @returns 服务数量
   */
  get size(): number {
    return this.services.size;
  }

  /**
   * 获取所有已注册的服务键
   * @returns 服务键数组
   */
  getKeys(): ServiceKey[] {
    return Array.from(this.services.keys());
  }
}
