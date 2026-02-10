/**
 * @file 用户信息仓库类
 * @description 实现用户信息相关请求
 * @author JunBin.Yang
 */
import { NetworkResult } from "@core/network";
import { User } from "@shared/types";
import { IUserInfoRepository } from "@shared/contracts";
import { UserInfoNetworkDataSource } from "./datasource/UserInfoNetworkDataSource";
import { UserInfoNetworkDataSourceImpl } from "./datasource/UserInfoNetworkDataSourceImpl";

/**
 * 用户信息仓库实现
 * 实现 shared/contracts 中定义的 IUserInfoRepository 接口
 */
export class UserInfoRepositoryImpl implements IUserInfoRepository {
  /**
   * 用户信息网络数据源
   */
  private networkDataSource: UserInfoNetworkDataSource;

  /**
   * 构造函数
   * @param {UserInfoNetworkDataSource} networkDataSource - 可选的用户信息数据源实例
   */
  constructor(networkDataSource?: UserInfoNetworkDataSource) {
    this.networkDataSource = networkDataSource ?? new UserInfoNetworkDataSourceImpl();
  }

  /**
   * 获取用户个人信息
   * @returns {Promise<NetworkResult<User>>} 用户信息响应
   */
  async getPersonInfo(): Promise<NetworkResult<User>> {
    return this.networkDataSource.getPersonInfo();
  }
}
