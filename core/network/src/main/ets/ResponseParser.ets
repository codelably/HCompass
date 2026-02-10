/**
 * @file 响应解析器接口
 * @description 定义网络响应的解析策略，支持不同后端响应格式
 * @author JunBin.Yang
 */

import { Unknown } from "@core/common";

/**
 * 响应解析器接口
 * 用于解析不同格式的后端响应
 * @template T 响应数据类型
 */
export interface ResponseParser<T = Unknown> {
  /**
   * 判断响应是否成功
   * @param response 原始响应数据
   * @returns 是否成功
   */
  isSuccess(response: Unknown): boolean;

  /**
   * 获取响应数据
   * @param response 原始响应数据
   * @returns 解析后的数据
   */
  getData(response: Unknown): T | null;

  /**
   * 获取响应消息
   * @param response 原始响应数据
   * @returns 响应消息
   */
  getMessage(response: Unknown): string | null;

  /**
   * 获取响应状态码
   * @param response 原始响应数据
   * @returns 状态码
   */
  getCode(response: Unknown): number;
}

/**
 * 响应解析器配置
 */
export interface ResponseParserConfig {
  /**
   * 成功状态码
   */
  successCode: number;

  /**
   * 数据字段名
   */
  dataField: string;

  /**
   * 消息字段名
   */
  messageField: string;

  /**
   * 状态码字段名
   */
  codeField: string;
}

/**
 * 默认响应解析器配置
 */
export const DEFAULT_PARSER_CONFIG: ResponseParserConfig = {
  successCode: 1000,
  dataField: 'data',
  messageField: 'message',
  codeField: 'code'
};
