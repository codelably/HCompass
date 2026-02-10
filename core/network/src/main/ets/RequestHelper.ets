/**
 * @file 请求助手
 * @description 提供链式调用的请求处理助手
 * @author JunBin.Yang
 */

import { Unknown } from "@core/common";
import { NetworkResult } from './NetworkResult';
import { ResponseParser } from './ResponseParser';
import { DefaultResponseParser } from './DefaultResponseParser';
import { NetworkConfig } from './NetworkConfig';
import { ToastUtils } from "@core/util";
import { getContainer, CoreServiceKeys } from "@core/di";

/**
 * 请求助手类
 * 提供链式调用的请求处理能力
 * @template T 响应数据类型
 */
export class RequestHelper<T> {
  /**
   * 原始请求 Promise（可能是原始响应或 NetworkResult）
   */
  private source: Promise<Unknown>;

  /**
   * 响应解析器
   */
  private parser: ResponseParser<T>;

  /**
   * 是否已经是 NetworkResult
   */
  private isNetworkResult: boolean = false;

  /**
   * 是否显示 loading
   */
  private useLoading: boolean = false;

  /**
   * 是否自动 toast 错误
   */
  private useToast: boolean = true;

  /**
   * 请求开始前的回调
   */
  private beforeStart?: () => void;

  /**
   * loading 显示回调
   */
  private showLoadingCallback?: () => void = () => {
    ToastUtils.showLoading();
  };

  /**
   * loading 隐藏回调
   */
  private hideLoadingCallback?: () => void = () => {
    ToastUtils.hide();
  };

  /**
   * toast 错误回调
   */
  private toastErrorCallback?: (message: string) => void = (message: string) => {
    ToastUtils.showError(message);
  };

  /**
   * 构造函数
   * @param promise 原始请求 Promise
   * @param parser 响应解析器
   * @param isNetworkResult 是否已经是 NetworkResult
   */
  private constructor(promise: Promise<Unknown>, parser?: ResponseParser<T>, isNetworkResult: boolean = false) {
    this.source = promise;
    this.parser = parser ?? this.createDefaultParser();
    this.isNetworkResult = isNetworkResult;
  }

  /**
   * 创建默认解析器
   * 优先从 DI 容器获取 NetworkConfig，如果失败则使用默认配置
   * @returns 响应解析器
   */
  private createDefaultParser(): ResponseParser<T> {
    try {
      const config = getContainer().tryResolve<NetworkConfig>(CoreServiceKeys.ConfigManager);
      if (config) {
        return new DefaultResponseParser<T>(config.responseParser);
      }
    } catch (e) {
      // 如果获取配置失败，使用默认配置
    }
    return new DefaultResponseParser<T>();
  }

  /**
   * 创建请求助手（从原始响应）
   * @param promise 原始请求 Promise
   * @param parser 响应解析器
   * @returns RequestHelper 实例
   */
  static from<T>(promise: Promise<Unknown>, parser?: ResponseParser<T>): RequestHelper<T> {
    return new RequestHelper<T>(promise, parser, false);
  }

  /**
   * 创建请求助手（从 NetworkResult）
   * @param promise NetworkResult Promise
   * @returns RequestHelper 实例
   */
  static fromResult<T>(promise: Promise<NetworkResult<T>>): RequestHelper<T> {
    return new RequestHelper<T>(promise as Promise<Unknown>, undefined, true);
  }

  /**
   * 设置请求开始前执行的回调
   * @param handler 前置回调
   * @returns 当前实例
   */
  start(handler: () => void): RequestHelper<T> {
    this.beforeStart = handler;
    return this;
  }

  /**
   * 配置是否展示 loading
   * @param enable 是否展示
   * @returns 当前实例
   */
  loading(enable: boolean = true): RequestHelper<T> {
    this.useLoading = enable;
    return this;
  }

  /**
   * 配置是否自动 toast 错误
   * @param enable 是否展示
   * @returns 当前实例
   */
  toast(enable: boolean = true): RequestHelper<T> {
    this.useToast = enable;
    return this;
  }

  /**
   * 设置 loading 回调
   * @param show 显示回调
   * @param hide 隐藏回调
   * @returns 当前实例
   */
  onLoading(show: () => void, hide: () => void): RequestHelper<T> {
    this.showLoadingCallback = show;
    this.hideLoadingCallback = hide;
    return this;
  }

  /**
   * 设置 toast 错误回调
   * @param callback toast 回调
   * @returns 当前实例
   */
  onError(callback: (message: string) => void): RequestHelper<T> {
    this.toastErrorCallback = callback;
    return this;
  }

  /**
   * 执行请求，返回数据
   * @returns 数据 Promise
   */
  async execute(): Promise<T> {
    const result = await this.executeInternal();
    if (!result.isSuccess) {
      throw new Error(result.message ?? '请求失败');
    }
    return result.data as T;
  }

  /**
   * 执行请求，返回完整响应
   * @returns NetworkResult Promise
   */
  async response(): Promise<NetworkResult<T>> {
    return this.executeInternal();
  }

  /**
   * 内部执行逻辑
   * @returns NetworkResult Promise
   */
  private async executeInternal(): Promise<NetworkResult<T>> {
    // 执行前置回调
    if (this.beforeStart) {
      this.beforeStart();
    }

    // 显示 loading
    if (this.useLoading && this.showLoadingCallback) {
      this.showLoadingCallback();
    }

    try {
      const rawResponse: Unknown = await this.source;

      // 如果已经是 NetworkResult，直接使用
      let result: NetworkResult<T>;
      if (this.isNetworkResult) {
        result = rawResponse as NetworkResult<T>;
      } else {
        // 否则创建新的 NetworkResult
        result = new NetworkResult<T>(rawResponse, this.parser);
      }

      if (!result.isSuccess && this.useToast && this.toastErrorCallback) {
        this.toastErrorCallback(result.message ?? '请求失败');
      }

      return result;
    } catch (e) {
      const error = e instanceof Error ? e : new Error('网络异常');

      console.log("####",JSON.stringify(error))
      if (this.useToast && this.toastErrorCallback) {
        this.toastErrorCallback(error.message);
      }

      return NetworkResult.error<T>(error);
    } finally {
      // 隐藏 loading
      if (this.useLoading && this.hideLoadingCallback) {
        this.hideLoadingCallback();
      }
    }
  }
}
