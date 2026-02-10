import { IBestCell, IBestCellGroup } from "@core/ibestui";
import { ColumnBase, MediumPaddingVerticalScroll, P100, SpaceVerticalSmall } from "@core/designsystem";
import { getWindowSafeAreaState, WindowSafeAreaState } from "@core/layoutstate";
import { AppNavDestination } from "@core/components";
import SafeAreaDemoViewModel from "../viewmodel/SafeAreaDemoViewModel";

/**
 * @file 安全区示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct SafeAreaDemoPage {
  /**
   * 安全区示例页 ViewModel
   */
  @Local
  private vm: SafeAreaDemoViewModel = new SafeAreaDemoViewModel();
  /**
   * 窗口安全区状态
   */
  @Local
  private windowSafeAreaState: WindowSafeAreaState = getWindowSafeAreaState();

  /**
   * 构建安全区示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_safe_area_title"),
      viewModel: this.vm
    }) {
      this.SafeAreaContent();
    }
  }

  /**
   * 安全区示例页内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private SafeAreaContent(): void {
    MediumPaddingVerticalScroll() {
      ColumnBase({ widthValue: P100 }) {
        Text($r("app.string.demo_safe_area_unit_tip"))
          .fontSize($r("app.float.body_medium"))
          .fontColor($r("app.color.text_subtitle"));

        SpaceVerticalSmall();

        IBestCellGroup({ inset: true, outerMargin: 0 }) {
          IBestCell({
            title: $r("app.string.demo_safe_area_top_label"),
            label: this.formatInset(this.windowSafeAreaState.topInset),
            hasBorder: true
          });

          IBestCell({
            title: $r("app.string.demo_safe_area_left_label"),
            label: this.formatInset(this.windowSafeAreaState.leftInset),
            hasBorder: true
          });

          IBestCell({
            title: $r("app.string.demo_safe_area_bottom_label"),
            label: this.formatInset(this.windowSafeAreaState.bottomInset),
            hasBorder: true
          });

          IBestCell({
            title: $r("app.string.demo_safe_area_right_label"),
            label: this.formatInset(this.windowSafeAreaState.rightInset),
            hasBorder: false
          });
        };
      };
    };
  }

  /**
   * 格式化安全区数值
   * @param {number} value - 安全区数值
   * @returns {string} 格式化后的文本
   */
  private formatInset(value: number): string {
    return value.toFixed(2);
  }
}
