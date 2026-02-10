import { BaseViewModel } from "@core/base";
import { CoreServiceKeys, getContainer } from "@core/di";
import { NavigationService } from "@core/navigation";
import { getUserState, UserState } from "@shared/state";

/**
 * @file 个人中心 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class ProfileViewModel extends BaseViewModel {
  /**
   * 全局用户状态
   */
  private readonly userState: UserState = getUserState();

  /**
   * 获取展示昵称
   * @returns {ResourceStr} 展示昵称
   */
  getDisplayNickName(): ResourceStr {
    const nickName: string = this.userState.getUserInfo().nickName?.trim() ?? "";
    return nickName.length > 0 ? nickName : $r("app.string.user_profile_nickname_empty");
  }

  /**
   * 获取展示用户 ID
   * @returns {ResourceStr} 展示用户 ID
   */
  getDisplayUserId(): ResourceStr {
    const userId: number = this.userState.getUserInfo().id ?? 0;
    return userId > 0 ? `${userId}` : $r("app.string.user_profile_id_empty");
  }

  /**
   * 获取展示手机号
   * @returns {ResourceStr} 展示手机号
   */
  getDisplayPhone(): ResourceStr {
    const phone: string = this.userState.getUserInfo().phone?.trim() ?? "";
    return phone.length > 0 ? phone : $r("app.string.user_profile_phone_empty");
  }

  /**
   * 执行退出登录
   * @returns {void} 无返回值
   */
  logout(): void {
    this.userState.logout();
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateBack();
  }
}
