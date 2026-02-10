/**
 * @file 网络配置接口
 * @description 定义网络请求的配置选项
 * @author JunBin.Yang
 */

import { ResponseParserConfig } from "./ResponseParser";

/**
 * 网络配置接口
 */
export interface NetworkConfig {
  /**
   * 基础 URL
   */
  baseUrl: string;

  /**
   * 请求超时时间（毫秒）
   */
  timeout: number;

  /**
   * 响应格式
   */
  responseParser?: ResponseParserConfig;

  /**
   * 默认请求头
   */
  headers?: Record<string, string>;

  /**
   * 是否启用日志
   */
  enableLog?: boolean;
}

/**
 * 默认网络配置
 */
export const DEFAULT_NETWORK_CONFIG: NetworkConfig = {
  baseUrl: '',
  timeout: 30000,
  responseParser: {
    successCode: 200,
    dataField: 'data',
    messageField: 'message',
    codeField: 'code'
  },
  headers: {
    'Content-Type': 'application/json'
  },
  enableLog: true
};
