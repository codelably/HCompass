import { Unknown } from "@core/common";
import { CoreServiceKeys, getContainer } from "@core/di";
import { AxiosHttpClient, NetworkResult } from "@core/network";
import { User } from "@shared/types";
import { UserInfoNetworkDataSource } from "./UserInfoNetworkDataSource";

/**
 * @file 用户信息相关数据源实现类
 * @author Joker.X
 */
export class UserInfoNetworkDataSourceImpl implements UserInfoNetworkDataSource {
  /**
   * 获取个人信息
   * @returns {Promise<NetworkResult<User>>} 个人信息
   */
  async getPersonInfo(): Promise<NetworkResult<User>> {
    const httpClient = getContainer().resolve<AxiosHttpClient>(CoreServiceKeys.HttpClient);
    const rawResponse: Unknown = await httpClient.get<Unknown>("user/info/person");
    return new NetworkResult<User>(rawResponse);
  }
}
