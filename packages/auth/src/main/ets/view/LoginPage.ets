import { IBestButton } from "@core/ibestui";
import { ColumnBase, MediumPaddingVerticalScroll, P100 } from "@core/designsystem";
import { AppNavDestination } from "@core/components";
import LoginViewModel from "../viewmodel/LoginViewModel";

/**
 * @file 登录页视图
 * @author Joker.X
 */
@ComponentV2
export struct LoginPage {
  /**
   * 登录页 ViewModel
   */
  @Local
  private vm: LoginViewModel = new LoginViewModel();

  /**
   * 构建登录页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.login_title"),
      viewModel: this.vm
    }) {
      this.LoginContent();
    }
  }

  /**
   * 登录页内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private LoginContent() {
    MediumPaddingVerticalScroll() {
      ColumnBase({ widthValue: P100 }) {
        IBestButton({
          text: $r("app.string.login_action"),
          type: "primary",
          buttonSize: "large",
          round: true,
          btnWidth: P100,
          loading: this.vm.isLoginLoading,
          disabled: this.vm.isLoginLoading,
          onBtnClick: (): void => {
            this.vm.login();
          }
        });
      };
    };
  }
}
