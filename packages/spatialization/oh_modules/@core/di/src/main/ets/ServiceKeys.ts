/**
 * @file 服务键定义
 * @description 框架级服务的标识符定义
 * @author JunBin.Yang
 */

/**
 * 框架核心服务键
 * 使用 Symbol 确保唯一性
 */
export const CoreServiceKeys = {
  /**
   * HTTP 客户端服务
   */
  HttpClient: Symbol('HttpClient'),

  /**
   * 导航服务
   */
  NavigationService: Symbol('NavigationService'),

  /**
   * 配置管理服务
   */
  ConfigManager: Symbol('ConfigManager')
} as const;

/**
 * 服务键类型
 */
export type CoreServiceKey = typeof CoreServiceKeys[keyof typeof CoreServiceKeys];
