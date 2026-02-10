import { NetworkResult } from "@core/network";
import { Auth, PasswordLoginRequest } from "@shared/types";

/**
 * @file 认证相关网络数据源接口
 * 定义认证模块所需的所有网络请求操作
 * @author Joker.X
 */
export interface AuthNetworkDataSource {
  /**
   * 刷新 Token
   * @param {Record<string, string>} params - 刷新参数，包含 refresh_token
   * @returns {Promise<NetworkResult<Auth>>} 刷新后的认证信息
   */
  refreshToken(params: Record<string, string>): Promise<NetworkResult<Auth>>;

  /**
   * 密码登录
   * @param params 登录参数，包含用户名、密码等
   * @return 返回 Promise，包含认证结果
   */
  loginByPassword(params: PasswordLoginRequest): Promise<NetworkResult<Auth>>;
}
