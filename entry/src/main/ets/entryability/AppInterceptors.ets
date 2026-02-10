/**
 * @file 全局网络拦截器
 * @author Joker.X
 */

import { AxiosResponse, InternalAxiosRequestConfig, AxiosHeaders, AxiosError } from "@ohos/axios";
import { HttpInterceptor } from "@core/network";
import { getUserState } from "@shared/state";
import { Logger } from "@core/util";
import { Unknown } from "@core/common";

const TAG: string = "NetLog";
const MAX_LOG_LENGTH: number = 800;

/**
 * 认证拦截器
 * 自动在请求头中添加 Authorization token
 */
export class AuthInterceptor implements HttpInterceptor {
  name = "AuthInterceptor";
  priority = 10;

  async onRequest(config: InternalAxiosRequestConfig): Promise<InternalAxiosRequestConfig> {
    const token = getUserState().getToken();
    if (token) {
      const headers: AxiosHeaders = AxiosHeaders.from(config.headers);
      headers.set("Authorization", token);
      config.headers = headers;
    }
    return config;
  }

  onRequestError(error: Error): Promise<never> {
    return Promise.reject(error);
  }
}

/**
 * 日志拦截器
 * 记录所有请求和响应的详细信息
 */
export class LogInterceptor implements HttpInterceptor {
  name = "LogInterceptor";
  priority = 1; // 优先级最高，最先执行

  onRequest(config: InternalAxiosRequestConfig): InternalAxiosRequestConfig {
    this.logRequest(config);
    return config;
  }

  onRequestError(error: AxiosError): Promise<never> {
    this.logRequestError(error);
    return Promise.reject(error);
  }

  onResponse(response: AxiosResponse): AxiosResponse {
    this.logResponse(response);
    return response;
  }

  onResponseError(error: AxiosError): Promise<never> {
    this.logResponseError(error);
    return Promise.reject(error);
  }

  /**
   * 打印请求日志
   */
  private logRequest(config: InternalAxiosRequestConfig): void {
    const method: string = this.normalizeMethod(config.method);
    const url: string = this.buildRequestUrl(config);
    const params: string = this.safeStringify(config.params as Unknown, true);
    const data: string = this.safeStringify(config.data as Unknown, true);
    this.logInfoLines([
      "[Network] Request",
      `method=${method}`,
      `url=${url}`,
      `params=${params}`,
      `data=${data}`
    ]);
  }

  /**
   * 打印请求错误日志
   */
  private logRequestError(error: AxiosError): void {
    const config: InternalAxiosRequestConfig | undefined = error.config as InternalAxiosRequestConfig | undefined;
    //const config = (error as ESObject)?.config as InternalAxiosRequestConfig | undefined;
    const method: string = config ? this.normalizeMethod(config.method) : "UNKNOWN";
    const url: string = config ? this.buildRequestUrl(config) : "unknown";
    const message: string = error.message || "unknown";
    this.logErrorLines([
      "[Network] Request Error",
      `method=${method}`,
      `url=${url}`,
      `message=${message}`
    ]);
  }

  /**
   * 打印响应日志
   */
  private logResponse(response: AxiosResponse): void {
    const config: InternalAxiosRequestConfig = response.config as InternalAxiosRequestConfig;
    const url: string = this.buildRequestUrl(config);
    const status: string = String(response.status);
    const data: string = this.safeStringify(response.data as Unknown, true);
    this.logInfoLines([
      "[Network] Response",
      `status=${status}`,
      `url=${url}`,
      `data=${data}`
    ]);
  }

  /**
   * 打印响应错误日志
   */
  private logResponseError(error: AxiosError): void {
    const config: InternalAxiosRequestConfig | undefined = error.config as InternalAxiosRequestConfig | undefined;
    const response: AxiosResponse | undefined = error.response as AxiosResponse | undefined;
    const url: string = response ? this.buildRequestUrl(response.config as InternalAxiosRequestConfig)
      : (config ? this.buildRequestUrl(config) : "unknown");
    const status: string = response?.status !== undefined ? String(response.status) : "UNKNOWN";
    const data: string = response ? this.safeStringify(response.data as Unknown, true) : "";
    const message: string = error.message || "unknown";
    this.logErrorLines([
      "[Network] Response Error",
      `status=${status}`,
      `url=${url}`,
      `message=${message}`,
      `data=${data}`
    ]);
  }

  /**
   * 规范化请求方法
   */
  private normalizeMethod(method?: string): string {
    return method ? method.toUpperCase() : "UNKNOWN";
  }

  /**
   * 拼接请求地址
   */
  private buildRequestUrl(config: InternalAxiosRequestConfig): string {
    const baseUrl: string = config.baseURL ?? "";
    const url: string = config.url ?? "";
    if (url.startsWith("http://") || url.startsWith("https://")) {
      return url;
    }
    // 处理 baseURL 与 url 的拼接，避免双斜杠
    if (baseUrl.endsWith("/") && url.startsWith("/")) {
      return `${baseUrl}${url.slice(1)}`;
    }
    if (!baseUrl.endsWith("/") && url && !url.startsWith("/")) {
      return `${baseUrl}/${url}`;
    }
    return `${baseUrl}${url}`;
  }

  /**
   * 安全序列化
   */
  private safeStringify(value: Unknown, pretty: boolean = false): string {
    if (value === undefined) {
      return "undefined";
    }
    if (typeof value === "string") {
      return value;
    }
    try {
      const result: string | undefined = JSON.stringify(value, null, pretty ? 2 : undefined);
      return result !== undefined ? result : String(value);
    } catch (err) {
      return "[Unserializable]";
    }
  }

  /**
   * 输出 info 日志（支持多行与分段）
   */
  private logInfoLines(lines: string[]): void {
    this.logLines("info", lines);
  }

  /**
   * 输出 error 日志（支持多行与分段）
   */
  private logErrorLines(lines: string[]): void {
    this.logLines("error", lines);
  }

  /**
   * 按行与长度分割日志，避免单条日志过长被截断
   */
  private logLines(level: "info" | "error", lines: string[]): void {
    const logger: (content: string, tag: string) => void =
      level === "error" ? Logger.error : Logger.info;
    lines.forEach((line: string) => {
      this.splitLines(line).forEach((segment: string) => {
        this.splitChunks(segment, MAX_LOG_LENGTH).forEach((chunk: string) => {
          logger(chunk, TAG);
        });
      });
    });
  }

  /**
   * 按换行符拆分字符串
   */
  private splitLines(value: string): string[] {
    if (!value) {
      return [""];
    }
    return value.split("\n");
  }

  /**
   * 按最大长度拆分字符串
   */
  private splitChunks(value: string, maxLength: number): string[] {
    if (value.length <= maxLength) {
      return [value];
    }
    const result: string[] = [];
    for (let start: number = 0; start < value.length; start += maxLength) {
      result.push(value.slice(start, start + maxLength));
    }
    return result;
  }
}
