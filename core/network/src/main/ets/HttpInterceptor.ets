/**
 * @file 请求拦截器接口
 * @description 定义请求和响应拦截器的接口
 * @author JunBin.Yang
 */

import type { InternalAxiosRequestConfig, AxiosResponse } from '@ohos/axios';

/**
 * 请求拦截器接口
 */
export interface RequestInterceptor {
  /**
   * 拦截器优先级，数字越小越先执行
   */
  priority?: number;

  /**
   * 请求拦截处理
   * @param config 请求配置
   * @returns 处理后的请求配置
   */
  onRequest?(config: InternalAxiosRequestConfig): InternalAxiosRequestConfig | Promise<InternalAxiosRequestConfig>;

  /**
   * 请求错误处理
   * @param error 错误对象
   * @returns 处理结果
   */
  onRequestError?(error: Error): Promise<never>;
}

/**
 * 响应拦截器接口
 */
export interface ResponseInterceptor {
  /**
   * 拦截器优先级，数字越小越先执行
   */
  priority?: number;

  /**
   * 响应拦截处理
   * @param response 响应对象
   * @returns 处理后的响应
   */
  onResponse?(response: AxiosResponse): AxiosResponse | Promise<AxiosResponse>;

  /**
   * 响应错误处理
   * @param error 错误对象
   * @returns 处理结果
   */
  onResponseError?(error: Error): Promise<never>;
}

/**
 * 完整拦截器接口（同时支持请求和响应拦截）
 */
export interface HttpInterceptor extends RequestInterceptor, ResponseInterceptor {
  /**
   * 拦截器名称（用于调试）
   */
  name?: string;
}
