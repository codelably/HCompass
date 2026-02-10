/**
 * @file 认证相关仓库类，定义认证模块请求
 * @author JunBin.Yang
 */

import { NetworkResult } from "@core/network";
import { Auth, PasswordLoginRequest } from "@shared/types";

/**
 * 定义跨功能包共享的 DI 服务键
 */
export const AUTH_REPOSITORY_KEY: string = "authRepository";

export interface IAuthRepository {
  /**
   * 刷新 Token
   * @param {Record<string, string>} params - 刷新参数
   * @returns {Promise<NetworkResult<Auth>>} 刷新后的认证信息
   */
  refreshToken(params: Record<string, string>): Promise<NetworkResult<Auth>>;

  /**
   * 密码登录
   * @param params 登录参数，包含用户名、密码等
   * @returns 包含认证信息的网络响应
   */
  loginByPassword(params: PasswordLoginRequest): Promise<NetworkResult<Auth>>;
}