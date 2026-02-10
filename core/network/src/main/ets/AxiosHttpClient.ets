/**
 * @file Axios HTTP 客户端实现
 * @description 基于 Axios 的 HTTP 客户端实现
 * @author JunBin.Yang
 */

import axios, { AxiosInstance, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import { HttpClient, RequestOptions } from './HttpClient';
import { NetworkConfig, DEFAULT_NETWORK_CONFIG } from './NetworkConfig';
import { HttpInterceptor } from './HttpInterceptor';
import { Unknown, ObjectAssign } from "@core/common";
import { Logger } from "@core/util";

const TAG: string = 'AxiosHttpClient';

/**
 * 基于 Axios 的 HTTP 客户端实现
 */
export class AxiosHttpClient implements HttpClient {
  /**
   * Axios 实例
   */
  private axiosInstance: AxiosInstance;

  /**
   * 网络配置
   */
  private config: NetworkConfig;

  /**
   * 拦截器列表
   */
  private interceptors: HttpInterceptor[] = [];

  /**
   * 拦截器 ID 映射
   */
  private interceptorIds: Map<HttpInterceptor, HttpID> = new Map();

  /**
   * 构造函数
   * @param config 网络配置
   */
  constructor(config?: Partial<NetworkConfig>) {
    this.config = ObjectAssign({} as NetworkConfig, DEFAULT_NETWORK_CONFIG, config);
    this.axiosInstance = axios.create({
      baseURL: this.config.baseUrl,
      timeout: this.config.timeout,
      headers: this.config.headers
    });
  }

  /**
   * GET 请求
   * @param url 请求地址
   * @param options 请求选项
   * @returns 响应数据
   */
  async get<T>(url: string, options?: RequestOptions): Promise<T> {
    this.logRequest('GET', url, options);
    const response: AxiosResponse<T> = await this.axiosInstance.get<T>(url, {
      headers: options?.headers,
      timeout: options?.timeout,
      params: options?.params
    });
    this.logResponse('GET', url, response);
    return response.data;
  }

  /**
   * POST 请求
   * @param url 请求地址
   * @param data 请求体
   * @param options 请求选项
   * @returns 响应数据
   */
  async post<T>(url: string, data?: Unknown, options?: RequestOptions): Promise<T> {
    this.logRequest('POST', url, options, data);
    const response: AxiosResponse<T> = await this.axiosInstance.post<T>(url, data, {
      headers: options?.headers,
      timeout: options?.timeout,
      params: options?.params
    });
    this.logResponse('POST', url, response);
    return response.data;
  }

  /**
   * PUT 请求
   * @param url 请求地址
   * @param data 请求体
   * @param options 请求选项
   * @returns 响应数据
   */
  async put<T>(url: string, data?: Unknown, options?: RequestOptions): Promise<T> {
    this.logRequest('PUT', url, options, data);
    const response: AxiosResponse<T> = await this.axiosInstance.put<T>(url, data, {
      headers: options?.headers,
      timeout: options?.timeout,
      params: options?.params
    });
    this.logResponse('PUT', url, response);
    return response.data;
  }

  /**
   * DELETE 请求
   * @param url 请求地址
   * @param options 请求选项
   * @returns 响应数据
   */
  async delete<T>(url: string, options?: RequestOptions): Promise<T> {
    this.logRequest('DELETE', url, options);
    const response: AxiosResponse<T> = await this.axiosInstance.delete<T>(url, {
      headers: options?.headers,
      timeout: options?.timeout,
      params: options?.params
    });
    this.logResponse('DELETE', url, response);
    return response.data;
  }

  /**
   * 添加拦截器
   * @param interceptor 拦截器实例
   */
  addInterceptor(interceptor: HttpInterceptor): void {
    // 按优先级排序插入
    const priority = interceptor.priority ?? 100;
    let insertIndex = this.interceptors.findIndex(i => (i.priority ?? 100) > priority);
    if (insertIndex === -1) {
      insertIndex = this.interceptors.length;
    }
    this.interceptors.splice(insertIndex, 0, interceptor);

    const ids: HttpID = {};

    // 注册请求拦截器
    if (interceptor.onRequest || interceptor.onRequestError) {
      ids.request = this.axiosInstance.interceptors.request.use(
        interceptor.onRequest
          ? (config: InternalAxiosRequestConfig) => interceptor.onRequest!(config)
          : undefined,
        interceptor.onRequestError
      );
    }

    // 注册响应拦截器
    if (interceptor.onResponse || interceptor.onResponseError) {
      ids.response = this.axiosInstance.interceptors.response.use(
        interceptor.onResponse
          ? (response: AxiosResponse) => interceptor.onResponse!(response)
          : undefined,
        interceptor.onResponseError
      );
    }

    this.interceptorIds.set(interceptor, ids);

    if (this.config.enableLog) {
      Logger.info(`Interceptor added: ${interceptor.name ?? 'unnamed'}`, TAG);
    }
  }

  /**
   * 移除拦截器
   * @param interceptor 拦截器实例
   */
  removeInterceptor(interceptor: HttpInterceptor): void {
    const index = this.interceptors.indexOf(interceptor);
    if (index !== -1) {
      this.interceptors.splice(index, 1);
    }

    const ids = this.interceptorIds.get(interceptor);
    if (ids) {
      if (ids.request !== undefined) {
        this.axiosInstance.interceptors.request.eject(ids.request);
      }
      if (ids.response !== undefined) {
        this.axiosInstance.interceptors.response.eject(ids.response);
      }
      this.interceptorIds.delete(interceptor);
    }

    if (this.config.enableLog) {
      Logger.info(`Interceptor removed: ${interceptor.name ?? 'unnamed'}`, TAG);
    }
  }

  /**
   * 获取当前配置
   * @returns 网络配置
   */
  getConfig(): NetworkConfig {
    return ObjectAssign({} as NetworkConfig, this.config);
  }

  /**
   * 更新配置
   * @param config 新配置
   */
  updateConfig(config: Partial<NetworkConfig>): void {
    this.config = ObjectAssign({} as NetworkConfig, this.config, config);
    // 更新 Axios 实例配置
    if (config.baseUrl !== undefined) {
      this.axiosInstance.defaults.baseURL = config.baseUrl;
    }
    if (config.timeout !== undefined) {
      this.axiosInstance.defaults.timeout = config.timeout;
    }
    if (config.headers !== undefined) {
      this.axiosInstance.defaults.headers.common = ObjectAssign({}, this.axiosInstance.defaults.headers.common, config.headers);
    }
  }

  /**
   * 获取 Axios 实例（高级用法）
   * @returns Axios 实例
   */
  getAxiosInstance(): AxiosInstance {
    return this.axiosInstance;
  }

  /**
   * 记录请求日志
   */
  private logRequest(method: string, url: string, options?: RequestOptions, data?: Unknown): void {
    if (this.config.enableLog) {
      Logger.info(`[${method}] ${url}`, TAG);
      if (options?.params) {
        Logger.info(`Params: ${JSON.stringify(options.params)}`, TAG);
      }
      if (data) {
        Logger.info(`Body: ${JSON.stringify(data)}`, TAG);
      }
    }
  }

  /**
   * 记录响应日志
   */
  private logResponse(method: string, url: string, response: AxiosResponse): void {
    if (this.config.enableLog) {
      Logger.info(`[${method}] ${url} -> ${response.status}`, TAG);
      Logger.info(`Response: ${JSON.stringify(response.data)}`, TAG);
    }
  }
}

interface HttpID {
  request?: number;
  response?: number;
}