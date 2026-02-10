import { BaseViewModel } from "@core/base";
import { IAuthRepository, AUTH_REPOSITORY_KEY } from '@shared/contracts';
import { Auth, PasswordLoginRequest } from "@shared/types";
import { RequestHelper } from "@core/network";
import { getUserState, UserState } from "@shared/state";
import { ToastUtils } from "@core/util";
import { CoreServiceKeys, getContainer } from "@core/di";
import { AuthRepositoryImpl } from "../services/AuthRepositoryImpl";
import { NavigationService } from "@core/navigation";

/**
 * @file 登录页 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class LoginViewModel extends BaseViewModel {
  /**
   * 全局用户状态
   */
  private readonly userState: UserState = getUserState();
  /**
   * 认证仓库
   */
  private readonly authRepository: IAuthRepository = getContainer().resolve<IAuthRepository>(AUTH_REPOSITORY_KEY, () => new AuthRepositoryImpl());
  /**
   * 登录按钮加载状态
   */
  @Trace
  isLoginLoading: boolean = false;

  /**
   * 执行登录操作
   * @returns {void} 无返回值
   */
  login(): void {
    const params: PasswordLoginRequest = new PasswordLoginRequest(
      "16666666666",
      "123456"
    );
    RequestHelper.fromResult<Auth>(this.authRepository.loginByPassword(params))
      .start(() => {
        this.isLoginLoading = true;
      })
      .execute()
      .then((authData: Auth) => {
        this.onLoginSuccess(authData);
      })
      .finally(() => {
        this.isLoginLoading = false;
      });
  }

  /**
   * 登录成功处理
   * @param {Auth} authData - 认证数据
   */
  private async onLoginSuccess(authData: Auth) {
    this.userState.updateAuth(authData);
    this.userState.refreshUserInfo();
    ToastUtils.showSuccess($r("app.string.login_success"));
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateBack();
  }
}
