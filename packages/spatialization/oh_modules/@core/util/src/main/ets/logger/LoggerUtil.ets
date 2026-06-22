/**
 * @file 日志工具
 * @author JunBin.Yang
 */

import { hilog } from "@kit.PerformanceAnalysisKit";
import { Any } from "@core/common"

/**
 * 定义日志级别枚举
 */
export enum LogLevel {
  DEBUG = hilog.LogLevel.DEBUG,
  INFO = hilog.LogLevel.INFO,
  WARN = hilog.LogLevel.WARN,
  ERROR = hilog.LogLevel.ERROR,
  FATAL = hilog.LogLevel.FATAL
}

/**
 * 定义日志选项接口
 */
export interface LogOption {
  domain: number;
  tag: string;
  icon: string;
  close: boolean;
}

/**
 * 抽象日志写入器接口，用于扩展不同的写入渠道
 */
export abstract class LogWriter {
  abstract write(level: LogLevel, domain: number, tag: string, ...message: Any[]): void;
}

/**
 * 默认日志写入器
 */
export class DefaultLogWriter extends LogWriter {
  constructor() {
    super();
  }

  write(level: LogLevel, domain: number, tag: string, message: string): void {
    switch (level) {
      case LogLevel.DEBUG:
        hilog.debug(domain, tag, message);
        break;
      case LogLevel.INFO:
        hilog.info(domain, tag, message);
        break;
      case LogLevel.WARN:
        hilog.warn(domain, tag, message);
        break;
      case LogLevel.ERROR:
        hilog.error(domain, tag, message);
        break;
      case LogLevel.FATAL:
        hilog.fatal(domain, tag, message);
        break;
    }
  }
}

/**
 * 日志工具核心类
 */
export class Logger {
  /**
   * 默认配置
   */
  private static option: LogOption = {
    domain: 0xFF00,
    tag: 'Arkly',
    icon: '🗒️',
    close: false
  };
  /**
   * 当前使用的日志写入器
   */
  private static writer: LogWriter = new DefaultLogWriter();
  /**
   * 初始化配置
   * @param option 配置项
   * @param writer 自定义写入器实例
   */
  static init(option: Partial<LogOption>, writer?: LogWriter) {
    if (option.domain !== undefined) Logger.option.domain = option.domain;
    if (option.tag !== undefined) Logger.option.tag = option.tag;
    if (option.icon !== undefined) Logger.option.icon = option.icon;
    if (option.close !== undefined) Logger.option.close = option.close;
    Logger.writer = writer ?? new DefaultLogWriter();
  }
  /**
   * 设置自定义日志写入器（用于扩展文件、远端服务等渠道）
   * @param writer 自定义写入器实例
   */
  static setWriter(writer: LogWriter) {
    Logger.writer = writer;
  }
  /**
   * 手动关闭所有日志输出
   */
  static disable() {
    Logger.option.close = true;
  }
  /**
   * 手动开启所有日志输出
   */
  static enable() {
    Logger.option.close = false;
  }
  /**
   * 调试级别日志
   * @param data 日志内容
   * @param tag 自定义标签
   */
  static debug(data: Any, tag?: string) {
    Logger.log(LogLevel.DEBUG, data, tag);
  }
  /**
   * 信息级别日志
   * @param data 日志内容
   * @param tag 自定义标签
   */
  static info(data: Any, tag?: string) {
    Logger.log(LogLevel.INFO, data, tag);
  }
  /**
   * 警告级别日志
   * @param data 日志内容
   * @param tag 自定义标签
   */
  static warn(data: Any, tag?: string) {
    Logger.log(LogLevel.WARN, data, tag);
  }
  /**
   * 错误级别日志
   * @param data 日志内容
   * @param tag 自定义标签
   */
  static error(data: Any, tag?: string) {
    Logger.log(LogLevel.ERROR, data, tag);
  }
  /**
   * 致命错误级别日志
   * @param data 日志内容
   * @param tag 自定义标签
   */
  static fatal(data: Any, tag?: string) {
    Logger.log(LogLevel.FATAL, data, tag);
  }
  /**
   * 核心日志处理方法
   * @param level 日志级别
   * @param data 日志内容
   * @param tag 自定义标签
   */
  private static log(level: LogLevel, data: Any, tag?: string) {
    if (Logger.option.close) return;
    const domain = Logger.option.domain!;
    const finalTag = tag || Logger.option.tag!;
    const message = Logger.format(data);
    /**
     * 通过写入器写入日志（解耦具体的输出方式）
     */
    Logger.writer.write(level, domain, finalTag, message);
  }
  /**
   * 格式化日志数据
   * @param data 原始数据
   * @returns 格式化后的字符串
   */
  private static format(data: Any): string {
    if (data === null || data === undefined) return 'null';

    switch (typeof data) {
      case "object":
        return Logger.objToJson(data);
      case "string":
        if (data.startsWith("{") && data.endsWith("}")) {
          try {
            return Logger.objToJson(JSON.parse(data));
          } catch (e) {
            return data;
          }
        } else {
          return data;
        }
      default:
        return String(data);
    }
  }
  /**
   * 对象转格式化的JSON字符串
   * @param data 目标对象
   * @returns 带图标缩进的JSON字符串
   */
  private static objToJson(data: object): string {
    const icon = Logger.option.icon || '|';
    return `${icon} ${JSON.stringify(data, null, 2).replace(/\n/g, `\n${icon} `)}`;
  }
}