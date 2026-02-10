/**
 * @file 主模块导航服务定义
 * @author JunBin.Yang
 */

/**
 * 定义跨功能包共享的 DI 服务键
 */
export const MAIN_NAV_SVC_KEY: string = "mainNavService";

/**
 * 导航服务定义，功能包内实现
 */
export interface IMainNavSvc {
  /**
   * 跳转到主框架
   * @returns {void} 无返回值
   */
  toMain(): void;
}