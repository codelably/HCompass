import { IBestButton, IBestCellGroup, IBestField, IBestFieldValueType } from "@core/ibestui";
import { ColumnBase, MediumPaddingVerticalScroll, P100, RowStartCenter, SpaceVerticalMedium } from "@core/designsystem";
import { AppNavDestination } from "@core/components";
import NavigationResultViewModel from "../viewmodel/NavigationResultViewModel";

/**
 * @file 结果回传示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct NavigationResultPage {
  /**
   * 结果回传示例页 ViewModel
   */
  @Local
  private vm: NavigationResultViewModel = new NavigationResultViewModel();

  /**
   * 构建结果回传示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_navigation_result_title"),
      viewModel: this.vm
    }) {
      this.NavigationResultContent();
    }
  }

  /**
   * 结果回传示例页内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private NavigationResultContent() {
    MediumPaddingVerticalScroll() {
      ColumnBase({ widthValue: P100 }) {
        this.InputSection();
      };
    };
  }

  /**
   * 输入区域
   * @returns {void} 无返回值
   */
  @Builder
  private InputSection(): void {
    ColumnBase({ widthValue: P100 }) {
      IBestCellGroup({ inset: true, outerMargin: 0 }) {
        IBestField({
          value: this.vm.titleInput,
          label: $r("app.string.demo_navigation_result_title_label"),
          placeholder: $r("app.string.demo_navigation_result_title_placeholder"),
          onChange: (value: IBestFieldValueType): void => {
            this.vm.updateTitleInput(value.toString());
          }
        });
        IBestField({
          value: this.vm.descInput,
          label: $r("app.string.demo_navigation_result_desc_label"),
          placeholder: $r("app.string.demo_navigation_result_desc_placeholder"),
          hasBorder: false,
          onChange: (value: IBestFieldValueType): void => {
            this.vm.updateDescInput(value.toString());
          }
        });
      };

      SpaceVerticalMedium();

      RowStartCenter() {
        IBestButton({
          text: $r("app.string.demo_navigation_result_action_submit"),
          type: "primary",
          buttonSize: "large",
          round: true,
          btnWidth: P100,
          onBtnClick: (): void => {
            this.vm.submitResult();
          }
        });
      };
    };
  }
}
