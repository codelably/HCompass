import { IBestButton } from "@core/ibestui";
import {
  MediumPaddingVerticalScroll, P100, SpaceVerticalLarge, SpaceVerticalSmall
} from "@core/designsystem";
import { AppNavDestination } from "@core/components";
import StateManagementViewModel from "../viewmodel/StateManagementViewModel";

/**
 * @file 状态管理示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct StateManagementPage {
  /**
   * 状态管理示例页 ViewModel
   */
  @Local
  private vm: StateManagementViewModel = new StateManagementViewModel();

  /**
   * 构建状态管理示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_state_management_title"),
      viewModel: this.vm
    }) {
      this.StateManagementContent();
    }
  }

  /**
   * 状态管理示例页内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private StateManagementContent() {
    MediumPaddingVerticalScroll() {
      Column() {
        Column() {
          Column() {
            Text($r("app.string.demo_state_management_count_label"))
              .fontSize($r("app.float.body_medium"))
              .fontColor($r("app.color.text_subtitle"));

            SpaceVerticalSmall();

            Text(`${this.vm.counterState.count}`)
              .fontSize($r("app.float.display_large"))
              .fontColor($r("app.color.text_primary"))
              .fontWeight(FontWeight.Bold);
          };
        }
        .width(P100)
        .padding($r("app.float.space_padding_medium"))
        .backgroundColor($r("app.color.bg_white"))
        .borderRadius($r("app.float.radius_medium"));

        SpaceVerticalLarge();

        IBestButton({
          text: $r("app.string.demo_state_management_action_decrement"),
          type: "default",
          btnWidth: P100,
          round: true,
          onBtnClick: (): void => {
            this.vm.decrement();
          }
        });

        SpaceVerticalLarge();

        IBestButton({
          text: $r("app.string.demo_state_management_action_increment"),
          type: "primary",
          btnWidth: P100,
          round: true,
          onBtnClick: (): void => {
            this.vm.increment();
          }
        });

        SpaceVerticalLarge();

        IBestButton({
          text: $r("app.string.demo_state_management_action_reset"),
          type: "danger",
          btnWidth: P100,
          plain: true,
          round: true,
          onBtnClick: (): void => {
            this.vm.reset();
          }
        })
      };
    };
  }
}
