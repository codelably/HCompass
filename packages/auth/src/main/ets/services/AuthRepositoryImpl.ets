/**
 * @file 认证相关仓库类
 * @description 实现认证模块请求
 * @author JunBin.Yang
 */
import { NetworkResult } from "@core/network";
import { Auth, PasswordLoginRequest } from "@shared/types";
import { IAuthRepository } from "@shared/contracts";
import { AuthNetworkDataSource } from "./datasource/AuthNetworkDataSource";
import { AuthNetworkDataSourceImpl } from "./datasource/AuthNetworkDataSourceImpl";

/**
 * 认证仓库实现类
 * 实现 shared/contracts 中定义的 IAuthRepository 接口
 */
export class AuthRepositoryImpl implements IAuthRepository {
  /**
   * 认证网络数据源
   */
  private networkDataSource: AuthNetworkDataSource;

  /**
   * 构造函数
   * @param networkDataSource 可选的认证网络数据源实例
   */
  constructor(networkDataSource?: AuthNetworkDataSource) {
    this.networkDataSource = networkDataSource ?? new AuthNetworkDataSourceImpl();
  }

  /**
   * 刷新 Token
   * @param {Record<string, string>} params - 刷新参数
   * @returns {Promise<NetworkResult<Auth>>} 刷新后的认证信息
   */
  async refreshToken(params: Record<string, string>): Promise<NetworkResult<Auth>> {
    return this.networkDataSource.refreshToken(params);
  }

  /**
   * 密码登录
   * @param params 登录参数，包含用户名、密码等
   * @returns 包含认证信息的网络响应
   */
  async loginByPassword(params: PasswordLoginRequest): Promise<NetworkResult<Auth>> {
    return this.networkDataSource.loginByPassword(params);
  }
}
