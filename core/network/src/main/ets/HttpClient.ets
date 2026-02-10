/**
 * @file HTTP 客户端接口
 * @description 定义 HTTP 客户端的抽象接口
 * @author JunBin.Yang
 */

import { Unknown } from "@core/common";
import { NetworkConfig } from './NetworkConfig';
import { HttpInterceptor } from './HttpInterceptor';

/**
 * 请求选项
 */
export interface RequestOptions {
  /**
   * 请求头
   */
  headers?: Record<string, string>;

  /**
   * 超时时间（毫秒）
   */
  timeout?: number;

  /**
   * URL 参数
   */
  params?: Record<string, Unknown>;
}

/**
 * HTTP 客户端接口
 */
export interface HttpClient {
  /**
   * GET 请求
   * @param url 请求地址
   * @param options 请求选项
   * @returns 响应数据
   */
  get<T>(url: string, options?: RequestOptions): Promise<T>;

  /**
   * POST 请求
   * @param url 请求地址
   * @param data 请求体
   * @param options 请求选项
   * @returns 响应数据
   */
  post<T>(url: string, data?: Unknown, options?: RequestOptions): Promise<T>;

  /**
   * PUT 请求
   * @param url 请求地址
   * @param data 请求体
   * @param options 请求选项
   * @returns 响应数据
   */
  put<T>(url: string, data?: Unknown, options?: RequestOptions): Promise<T>;

  /**
   * DELETE 请求
   * @param url 请求地址
   * @param options 请求选项
   * @returns 响应数据
   */
  delete<T>(url: string, options?: RequestOptions): Promise<T>;

  /**
   * 添加拦截器
   * @param interceptor 拦截器实例
   */
  addInterceptor(interceptor: HttpInterceptor): void;

  /**
   * 移除拦截器
   * @param interceptor 拦截器实例
   */
  removeInterceptor(interceptor: HttpInterceptor): void;

  /**
   * 获取当前配置
   * @returns 网络配置
   */
  getConfig(): NetworkConfig;

  /**
   * 更新配置
   * @param config 新配置
   */
  updateConfig(config: Partial<NetworkConfig>): void;
}
