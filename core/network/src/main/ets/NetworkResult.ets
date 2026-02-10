/**
 * @file 网络响应封装
 * @description 统一的网络响应模型，支持可配置的解析策略
 * @author JunBin.Yang
 */

import { Unknown } from "@core/common";
import { ResponseParser } from './ResponseParser';
import { DefaultResponseParser } from './DefaultResponseParser';

/**
 * 标准网络响应结构
 */
export interface StandardResponse<T = Unknown> {
  code: number;
  data: T | null;
  message?: string;
}

/**
 * 网络响应封装类
 * @template T 响应数据类型
 */
export class NetworkResult<T> {
  /**
   * 响应数据
   */
  readonly data: T | null;

  /**
   * 状态码
   */
  readonly code: number;

  /**
   * 响应消息
   */
  readonly message: string | null;

  /**
   * 是否成功
   */
  readonly isSuccess: boolean;

  /**
   * 原始响应
   */
  readonly rawResponse: Unknown;

  /**
   * 构造函数
   * @param rawResponse 原始响应数据
   * @param parser 响应解析器
   */
  constructor(rawResponse: Unknown, parser?: ResponseParser<T>) {
    const responseParser = parser ?? new DefaultResponseParser<T>();

    this.rawResponse = rawResponse;
    this.isSuccess = responseParser.isSuccess(rawResponse);
    this.data = responseParser.getData(rawResponse);
    this.message = responseParser.getMessage(rawResponse);
    this.code = responseParser.getCode(rawResponse);
  }

  /**
   * 创建成功响应
   * @param data 响应数据
   * @param message 响应消息
   * @returns NetworkResult 实例
   */
  static success<T>(data: T, message?: string): NetworkResult<T> {
    return new NetworkResult<T>({
      code: 200,
      data,
      message: message ?? 'success'
    } as StandardResponse<T>);
  }

  /**
   * 创建失败响应
   * @param code 错误码
   * @param message 错误消息
   * @returns NetworkResult 实例
   */
  static failure<T>(code: number, message: string): NetworkResult<T> {
    return new NetworkResult<T>({
      code,
      data: null,
      message
    } as StandardResponse<T>);
  }

  /**
   * 创建异常响应
   * @param error 异常对象
   * @returns NetworkResult 实例
   */
  static error<T>(error: Error): NetworkResult<T> {
    return new NetworkResult<T>({
      code: -1,
      data: null,
      message: error.message ?? '网络异常'
    } as StandardResponse<T>);
  }
}
