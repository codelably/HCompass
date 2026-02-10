import { User } from "@shared/types";
import { NetworkResult } from "@core/network";

/**
 * @file 用户信息相关数据源接口
 * @author Joker.X
 */
export interface UserInfoNetworkDataSource {
  /**
   * 获取用户个人信息
   * @returns 用户信息响应
   */
  getPersonInfo(): Promise<NetworkResult<User>>;
}
