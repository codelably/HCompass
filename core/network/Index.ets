/**
 * @file Network 模块导出
 * @description 网络抽象层模块的统一导出
 * @author JunBin.Yang
 */

// 配置导出
export type { NetworkConfig } from './src/main/ets/NetworkConfig';
export { DEFAULT_NETWORK_CONFIG } from './src/main/ets/NetworkConfig';

// 响应解析器导出
export type { ResponseParser, ResponseParserConfig } from './src/main/ets/ResponseParser';
export { DEFAULT_PARSER_CONFIG } from './src/main/ets/ResponseParser';
export { DefaultResponseParser } from './src/main/ets/DefaultResponseParser';

// HTTP 客户端导出
export type { HttpClient, RequestOptions } from './src/main/ets/HttpClient';
export { AxiosHttpClient } from './src/main/ets/AxiosHttpClient';

// 拦截器导出
export type { HttpInterceptor, RequestInterceptor, ResponseInterceptor } from './src/main/ets/HttpInterceptor';

// 响应结果导出
export { NetworkResult } from './src/main/ets/NetworkResult';

// 请求助手导出
export { RequestHelper } from './src/main/ets/RequestHelper';

// 分页类型导出
export { NetworkPageData } from './src/main/ets/NetworkPageData';
export { NetworkPageMeta } from './src/main/ets/NetworkPageMeta';
