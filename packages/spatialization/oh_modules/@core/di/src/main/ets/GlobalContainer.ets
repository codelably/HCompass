/**
 * @file 全局容器实例
 * @description 提供全局单例容器和便捷访问方法
 * @author JunBin.Yang
 */

import { Container } from './Container';
import { ServiceContainer } from './ServiceContainer';
import { ServiceKey, ServiceFactory, ServiceOptions } from './ServiceProvider';

/**
 * 全局容器实例
 */
let globalContainer: Container = new ServiceContainer();

/**
 * 获取全局容器实例
 * @returns 全局容器
 */
export function getContainer(): Container {
  return globalContainer;
}

/**
 * 设置全局容器实例
 * 用于测试或自定义容器场景
 * @param container 容器实例
 */
export function setContainer(container: Container): void {
  globalContainer = container;
}

/**
 * 重置全局容器
 * 清空所有注册的服务并创建新容器
 */
export function resetContainer(): void {
  globalContainer = new ServiceContainer();
}

/**
 * 注册服务到全局容器
 * @template T 服务类型
 * @param key 服务标识符
 * @param factory 服务工厂函数
 * @param options 注册选项
 */
export function register<T>(key: ServiceKey, factory: ServiceFactory<T>, options?: ServiceOptions): void {
  globalContainer.register<T>(key, factory, options);
}

/**
 * 从全局容器解析服务
 * @template T 服务类型
 * @param key 服务标识符
 * @param default_factory 默认服务工厂函数
 * @returns 服务实例
 */
export function resolve<T>(key: ServiceKey, default_factory?: ServiceFactory<T>): T {
  return globalContainer.resolve<T>(key, default_factory);
}

/**
 * 尝试从全局容器解析服务
 * @template T 服务类型
 * @param key 服务标识符
 * @returns 服务实例或 undefined
 */
export function tryResolve<T>(key: ServiceKey): T | undefined {
  return globalContainer.tryResolve<T>(key);
}

/**
 * 检查全局容器中服务是否已注册
 * @param key 服务标识符
 * @returns 是否已注册
 */
export function has(key: ServiceKey): boolean {
  return globalContainer.has(key);
}
