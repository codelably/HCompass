/**
 * @file 认证模块导航服务定义
 * @author JunBin.Yang
 */

/**
 * 定义跨功能包共享的 DI 服务键
 */
export const AUTH_NAV_SVC_KEY: string = "authNavService";

/**
 * 导航服务定义，功能包内实现
 */
export interface IAuthNavSvc {
  /**
   * 跳转到登录页面
   * @returns {void} 无返回值
   */
  toLogin(): void;
}

