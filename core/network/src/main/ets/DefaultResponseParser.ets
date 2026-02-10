/**
 * @file 默认响应解析器实现
 * @description 提供可配置的响应解析器实现
 * @author JunBin.Yang
 */

import { Unknown, ObjectAssign } from "@core/common";
import { ResponseParser, ResponseParserConfig, DEFAULT_PARSER_CONFIG } from './ResponseParser';

/**
 * 默认响应解析器
 * 支持通过配置适配不同的后端响应格式
 * @template T 响应数据类型
 */
export class DefaultResponseParser<T = Unknown> implements ResponseParser<T> {
  /**
   * 解析器配置
   */
  private config: ResponseParserConfig;

  /**
   * 构造函数
   * @param config 解析器配置，可选
   */
  constructor(config?: Partial<ResponseParserConfig>) {
    this.config = ObjectAssign({} as ResponseParserConfig, DEFAULT_PARSER_CONFIG, config);
  }

  /**
   * 判断响应是否成功
   * @param response 原始响应数据
   * @returns 是否成功
   */
  isSuccess(response: Unknown): boolean {
    if (!response || typeof response !== 'object') {
      return false;
    }
    const code = this.getCode(response);
    return code === this.config.successCode;
  }

  /**
   * 获取响应数据
   * @param response 原始响应数据
   * @returns 解析后的数据
   */
  getData(response: Unknown): T | null {
    if (!response || typeof response !== 'object') {
      return null;
    }
    const data = (response as Record<string, T>)[this.config.dataField];
    return (data as T) ?? null;
  }

  /**
   * 获取响应消息
   * @param response 原始响应数据
   * @returns 响应消息
   */
  getMessage(response: Unknown): string | null {
    if (!response || typeof response !== 'object') {
      return null;
    }
    const message = (response as Record<string, T>)[this.config.messageField];
    return typeof message === 'string' ? message : null;
  }

  /**
   * 获取响应状态码
   * @param response 原始响应数据
   * @returns 状态码
   */
  getCode(response: Unknown): number {
    if (!response || typeof response !== 'object') {
      return -1;
    }
    const code = (response as Record<string, T>)[this.config.codeField];
    return typeof code === 'number' ? code : -1;
  }

  /**
   * 获取当前配置
   * @returns 解析器配置
   */
  getConfig(): ResponseParserConfig {
    return ObjectAssign({} as ResponseParserConfig, this.config);
  }

  /**
   * 更新配置
   * @param config 新配置
   */
  updateConfig(config: Partial<ResponseParserConfig>): void {
    this.config = ObjectAssign({} as ResponseParserConfig, this.config, config);
  }
}
