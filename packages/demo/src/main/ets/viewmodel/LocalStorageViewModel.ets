import { BaseViewModel } from "@core/base";
import { getContainer } from "@core/di";
import { ACCOUNT_STORE_REPOSITORY_KEY, IAccountStoreRepository } from "@shared/contracts";
import { AccountStoreRepositoryImpl } from "../services/AccountStoreRepositoryImpl";

/**
 * @file 本地存储示例页 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class LocalStorageViewModel extends BaseViewModel {
  /**
   * 账号输入
   */
  @Trace
  accountInput: string = "";
  /**
   * 已存储账号
   */
  @Trace
  storedAccount: string = "";
  /**
   * 本地存储仓库
   */
  private repository: IAccountStoreRepository = getContainer().resolve<IAccountStoreRepository>(ACCOUNT_STORE_REPOSITORY_KEY, () => new AccountStoreRepositoryImpl());

  /**
   * 更新账号输入
   * @param {string} value - 输入内容
   * @returns {void} 无返回值
   */
  updateAccountInput(value: string): void {
    this.accountInput = value;
  }

  /**
   * 保存账号
   * @returns {Promise<void>} Promise<void>
   */
  async saveAccount(): Promise<void> {
    const account: string = this.accountInput.trim();
    if (!account) {
      return;
    }
    await this.repository.saveAccount(account);
  }

  /**
   * 读取账号
   * @returns {Promise<void>} Promise<void>
   */
  async loadAccount(): Promise<void> {
    this.storedAccount = await this.repository.loadAccount();
  }
}
