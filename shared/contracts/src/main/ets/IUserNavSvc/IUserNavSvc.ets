/**
 * @file 用户模块导航服务定义
 * @author JunBin.Yang
 */

/**
 * 定义跨功能包共享的 DI 服务键
 */
export const USER_NAV_SVC_KEY: string = "userNavService";

/**
 * 导航服务抽象，功能包内实现
 */
export interface IUserNavSvc {
  /**
   * 跳转到个人中心
   * @returns {void} 无返回值
   */
  toProfile(): void;
}