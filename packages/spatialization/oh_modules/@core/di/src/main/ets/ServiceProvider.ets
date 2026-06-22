/**
 * @file 服务提供者类型定义
 * @description 定义服务工厂函数和服务描述符类型
 * @author JunBin.Yang
 */

import { Symbol } from "@core/common";

/**
 * 服务标识符类型
 * 支持 string 和 symbol 两种形式
 */
export type ServiceKey = string | Symbol;

/**
 * 服务工厂函数类型
 * @template T 服务类型
 */
export type ServiceFactory<T> = () => T;

/**
 * 服务描述符
 * @template T 服务类型
 */
export interface ServiceDescriptor<T> {
  /**
   * 服务工厂函数
   */
  factory: ServiceFactory<T>;
  /**
   * 是否为单例模式
   */
  singleton: boolean;
  /**
   * 单例实例缓存
   */
  instance?: T;
}

/**
 * 服务注册选项
 */
export interface ServiceOptions {
  /**
   * 是否为单例模式，默认 true
   */
  singleton?: boolean;
}
