/**
 * @file 用户信息仓库，定义用户信息相关请求
 * @author JunBin.Yang
 */

import { NetworkResult } from "@core/network";
import { User } from "@shared/types";

/**
 * 定义跨功能包共享的 DI 服务键
 */
export const USER_INFO_REPOSITORY_KEY: string = "userInfoRepository";

export interface IUserInfoRepository {
  /**
   * 获取用户个人信息
   * @returns {Promise<NetworkResult<User>>} 用户信息响应
   */
  getPersonInfo(): Promise<NetworkResult<User>>;
}