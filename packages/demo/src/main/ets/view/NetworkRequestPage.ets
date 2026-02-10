import { IBestButton } from "@core/ibestui";
import { ColumnBase, MediumPaddingVerticalScroll, P100, SpaceVerticalLarge } from "@core/designsystem";
import { AppNavDestination } from "@core/components";
import NetworkRequestViewModel from "../viewmodel/NetworkRequestViewModel";

/**
 * @file 通用网络请求示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct NetworkRequestPage {
  /**
   * 通用网络请求示例页 ViewModel
   */
  @Local
  private vm: NetworkRequestViewModel = new NetworkRequestViewModel();

  /**
   * 构建通用网络请求示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_network_request_title"),
      viewModel: this.vm
    }) {
      this.NetworkRequestContent();
    }
  }

  /**
   * 通用网络请求示例页内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private NetworkRequestContent() {
    MediumPaddingVerticalScroll() {
      ColumnBase({ widthValue: P100 }) {
        IBestButton({
          text: $r("app.string.demo_network_request_get_action"),
          type: "primary",
          buttonSize: "normal",
          btnWidth: P100,
          round: true,
          loading: this.vm.getLoading,
          disabled: this.vm.getLoading,
          onBtnClick: (): void => {
            this.vm.requestGoodsDetail();
          }
        });

        SpaceVerticalLarge();

        IBestButton({
          text: $r("app.string.demo_network_request_post_action"),
          type: "default",
          plain: true,
          buttonSize: "normal",
          btnWidth: P100,
          round: true,
          loading: this.vm.postLoading,
          disabled: this.vm.postLoading,
          onBtnClick: (): void => {
            this.vm.requestGoodsList();
          }
        });
      };
    };
  }
}
