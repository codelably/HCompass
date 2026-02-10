/**
 * @file 账号密码本地存储仓库，定义存取逻辑
 * @author JunBin.Yang
 */

/**
 * 定义跨功能包共享的 DI 服务键
 */
export const ACCOUNT_STORE_REPOSITORY_KEY: string = "accountStoreRepository";

export interface IAccountStoreRepository {
  /**
   * 保存账号
   * @param {string} account 用户账号
   * @returns {Promise<void>} Promise<void>
   */
  saveAccount(account: string): Promise<void>;

  /**
   * 读取账号
   * @returns {Promise<string>} 用户账号，默认空字符串
   */
  loadAccount(): Promise<string>;

  /**
   * 保存密码
   * @param {string} password 用户密码
   * @returns {Promise<void>} Promise<void>
   */
  savePassword(password: string): Promise<void>;

  /**
   * 读取密码
   * @returns {Promise<string>} 用户密码，默认空字符串
   */
  loadPassword(): Promise<string>;
}