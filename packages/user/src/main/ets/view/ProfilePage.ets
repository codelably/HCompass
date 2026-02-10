import { IBestButton, IBestCell, IBestCellGroup } from "@core/ibestui";
import { ColumnBase, MediumPaddingVerticalScroll, P100, SpaceVerticalLarge } from "@core/designsystem";
import { AppNavDestination } from "@core/components";
import ProfileViewModel from "../viewmodel/ProfileViewModel";

/**
 * @file 个人中心视图
 * @author Joker.X
 */
@ComponentV2
export struct ProfilePage {
  /**
   * 个人中心 ViewModel
   */
  @Local
  private vm: ProfileViewModel = new ProfileViewModel();

  /**
   * 构建个人中心页面
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.user_profile_title"),
      viewModel: this.vm
    }) {
      this.ProfileContent();
    }
  }

  /**
   * 个人中心内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private ProfileContent() {
    MediumPaddingVerticalScroll() {
      ColumnBase({ widthValue: P100 }) {
        IBestCellGroup({ inset: true, outerMargin: 0 }) {
          IBestCell({
            title: $r("app.string.user_profile_nickname_label"),
            value: this.vm.getDisplayNickName(),
            hasBorder: true
          });
          IBestCell({
            title: $r("app.string.user_profile_id_label"),
            value: this.vm.getDisplayUserId(),
            hasBorder: true
          });
          IBestCell({
            title: $r("app.string.user_profile_phone_label"),
            value: this.vm.getDisplayPhone(),
            hasBorder: false
          });
        };

        SpaceVerticalLarge();

        IBestButton({
          text: $r("app.string.user_profile_logout_action"),
          round: true,
          type: "primary",
          buttonSize: "normal",
          btnWidth: P100,
          onBtnClick: (): void => {
            this.vm.logout();
          }
        });
      };
    };
  }
}
