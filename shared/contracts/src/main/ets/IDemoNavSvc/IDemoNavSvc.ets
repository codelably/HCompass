/**
 * @file Demo 模块导航服务定义
 * @author JunBin.Yang
 */

import { DemoResult } from "./DemoResult";

/**
 * 定义跨功能包共享的 DI 服务键
 */
export const DEMO_NAV_SVC_KEY: string = "demoNavService";

/**
 * 导航服务定义，功能包内实现
 */
export interface IDemoNavSvc {
  /**
   * 跳转到 Network Demo 示例页
   * @returns {void} 无返回值
   */
  toNetworkDemo(): void;

  /**
   * 跳转到 Network List Demo 示例页
   * @returns {void} 无返回值
   */
  toNetworkListDemo(): void;

  /**
   * 跳转到数据库示例页
   * @returns {void} 无返回值
   */
  toDatabase(): void;

  /**
   * 跳转到本地存储示例页
   * @returns {void} 无返回值
   */
  toLocalStorage(): void;

  /**
   * 跳转到状态管理示例页
   * @returns {void} 无返回值
   */
  toStateManagement(): void;

  /**
   * 跳转到通用网络请求示例页
   * @returns {void} 无返回值
   */
  toNetworkRequest(): void;

  /**
   * 跳转到带参跳转示例页
   * @param {number} goodsId - 商品 ID
   * @param {Resource} goodsName - 商品名称
   * @returns {void} 无返回值
   */
  toNavigationWithArgs(goodsId: number, goodsName: Resource): void;

  /**
   * 跳转到结果回传示例页
   * @returns {Promise<DemoResult | undefined>} 返回结果 Promise
   */
  toNavigationResult(): Promise<DemoResult | undefined>;

  /**
   * 跳转到安全区示例页
   * @returns {void} 无返回值
   */
  toSafeAreaDemo(): void;

  /**
   * 跳转到屏幕适配示例页
   * @returns {void} 无返回值
   */
  toScreenAdaptDemo(): void;
}