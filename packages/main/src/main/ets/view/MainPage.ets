import { AppNavDestination } from "@core/components";
import { ColumnCenter, P100, size, SpaceVerticalXSmall } from "@core/designsystem";
import {
  bp, BreakpointState, getBreakpointState, getWindowSafeAreaState, WindowSafeAreaState
} from "@core/layoutstate";
import MainViewModel from "../viewmodel/MainViewModel";
import { CorePage } from "./CorePage";
import { NavigationPage } from "./NavigationPage";
import { ExpandPage } from "./ExpandPage";
import { AboutPage } from "./AboutPage";

/**
 * @file 主页面视图
 * @author Joker.X
 */
@ComponentV2
export struct MainPage {
  /**
   * 主页面 ViewModel
   */
  @Local
  private vm: MainViewModel = new MainViewModel();
  /**
   * 窗口安全区状态
   */
  @Local
  private windowSafeAreaState: WindowSafeAreaState = getWindowSafeAreaState();
  /**
   * 屏幕断点状态
   */
  @Local
  private breakpointState: BreakpointState = getBreakpointState();

  /**
   * 构建主页面
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      hideTitleBar: true,
      viewModel: this.vm,
      safeAreaEnabled: false
    }) {
      this.MainContent();
    }
  }

  /**
   * 主页面内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private MainContent() {
    Tabs({
      index: this.vm.currentPageIndex,
      barPosition: this.breakpointState.isLG() ? BarPosition.Start : BarPosition.End,
    }) {
      TabContent() {
        CorePage();
      }.tabBar(this.tabBarItem(0));

      TabContent() {
        NavigationPage();
      }.tabBar(this.tabBarItem(1));

      TabContent() {
        ExpandPage();
      }.tabBar(this.tabBarItem(2));

      TabContent() {
        AboutPage();
      }.tabBar(this.tabBarItem(3));
    }
    .width(P100)
    .height(P100)
    .barWidth(this.breakpointState.isLG() ? 96 : P100)
    .divider({ strokeWidth: 0 })
    .backgroundColor($r("app.color.bg_white"))
    .barBackgroundBlurStyle(BlurStyle.Thin)
    .cachedMaxCount(this.vm.tabItems.length, TabsCacheMode.CACHE_BOTH_SIDE)
    .barMode(BarMode.Fixed)
    .scrollable(true)
    .vertical(this.breakpointState.isLG())
    .onChange((index: number) => this.vm.handleTabChanged(index))
    .padding({ bottom: this.windowSafeAreaState.bottomInset });
  }

  /**
   * Tabs 的底部导航项
   * @param {number} index - 索引
   * @returns {void} 无返回值
   */
  @Builder
  private tabBarItem(index: number) {
    ColumnCenter() {
      Image(this.vm.tabItems[index].icon)
        .attributeModifier(size(bp({
          sm: 20,
          md: 22,
          lg: 24,
        })))
        .fillColor(this.vm.currentPageIndex === index ?
          $r("app.color.primary") :
          $r("app.color.text_subtitle"));

      SpaceVerticalXSmall();

      Text(this.vm.tabItems[index].title)
        .fontSize(bp({
          sm: $r("app.float.body_medium"),
          md: $r("app.float.body_large"),
          lg: $r("app.float.headline_large")
        }))
        .fontColor(this.vm.currentPageIndex === index ?
          $r("app.color.primary") :
          $r("app.color.text_subtitle"))
        .textAlign(TextAlign.Center);
    };
  }
}
