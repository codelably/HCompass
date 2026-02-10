import { Unknown } from "@core/common";
import { CoreServiceKeys, getContainer } from "@core/di";
import { AxiosHttpClient, NetworkResult } from "@core/network";
import { Auth, PasswordLoginRequest } from "@shared/types";
import { AuthNetworkDataSource } from "./AuthNetworkDataSource";

/**
 * @file 认证相关网络数据源实现类
 * @author Joker.X
 */
export class AuthNetworkDataSourceImpl implements AuthNetworkDataSource {
  /**
   * 刷新 Token
   * @param {Record<string, string>} params - 刷新参数
   * @returns {Promise<NetworkResult<Auth>>} 刷新后的认证信息
   */
  async refreshToken(params: Record<string, string>): Promise<NetworkResult<Auth>> {
    const httpClient = getContainer().resolve<AxiosHttpClient>(CoreServiceKeys.HttpClient);
    const rawResponse: Unknown = await httpClient.post<Unknown>("user/login/refreshToken", params);
    return new NetworkResult<Auth>(rawResponse);
  }

  /**
   * 密码登录实现
   * @param {PasswordLoginRequest} params - 登录参数
   * @returns {Promise<NetworkResult<Auth>>} 登录结果
   */
  async loginByPassword(params: PasswordLoginRequest): Promise<NetworkResult<Auth>> {
    const httpClient = getContainer().resolve<AxiosHttpClient>(CoreServiceKeys.HttpClient);
    const rawResponse: Unknown = await httpClient.post<Unknown>("user/login/password", params);
    return new NetworkResult<Auth>(rawResponse);
  }
}
