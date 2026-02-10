import { IBestCell, IBestCellGroup } from "@core/ibestui";
import { ColumnBase, MediumPaddingVerticalScroll, P100, P80, SpaceVerticalLarge } from "@core/designsystem";
import { AppNavDestination } from "@core/components";
import { getWindowSafeAreaState, WindowSafeAreaState } from "@core/layoutstate";
import NavigationViewModel from "../viewmodel/NavigationViewModel";
import { NavigationCardItem } from "../models/NavigationCardItem";

/**
 * @file 导航页面视图
 * @author Joker.X
 */
@ComponentV2
export struct NavigationPage {
  /**
   * 导航页面 ViewModel
   */
  @Local
  private vm: NavigationViewModel = new NavigationViewModel();
  /**
   * 窗口安全区状态
   */
  @Local
  private windowSafeAreaState: WindowSafeAreaState = getWindowSafeAreaState();

  /**
   * 构建导航页面
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.navigation"),
      viewModel: this.vm,
      paddingValue: {
        top: this.windowSafeAreaState.topInset,
        left: this.windowSafeAreaState.leftInset,
        right: this.windowSafeAreaState.rightInset,
      }
    }) {
      this.NavigationContent();
    }
  }

  /**
   * 导航页面内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private NavigationContent() {
    MediumPaddingVerticalScroll() {
      ColumnBase({ widthValue: P100 }) {
        if (this.vm.hasResult) {
          this.ResultSection();
          SpaceVerticalLarge();
        }

        IBestCellGroup({ inset: true, outerMargin: 0 }) {
          ForEach(this.vm.cards, (item: NavigationCardItem, index: number) => {
            IBestCell({
              title: item.title,
              label: item.description,
              isLink: true,
              leftContentWidth: P80,
              hasBorder: index !== this.vm.cards.length - 1,
              onCellClick: () => item.onClick()
            });
          }, (_item: NavigationCardItem, index: number) => `${index}`);
        };
      };
    };
  }

  /**
   * 结果回传展示区
   * @returns {void} 无返回值
   */
  @Builder
  private ResultSection(): void {
    if (this.vm.shouldShowResult()) {
      IBestCellGroup({ inset: true, outerMargin: 0 }) {
        if (this.vm.hasResultTitle()) {
          IBestCell({
            title: $r("app.string.main_navigation_result_title_label"),
            label: this.vm.resultTitle,
            isLink: false,
            hasBorder: this.vm.hasResultDesc()
          });
        }
        if (this.vm.hasResultDesc()) {
          IBestCell({
            title: $r("app.string.main_navigation_result_desc_label"),
            label: this.vm.resultDescription,
            isLink: false,
            hasBorder: false
          });
        }
      };
    }
  }
}
