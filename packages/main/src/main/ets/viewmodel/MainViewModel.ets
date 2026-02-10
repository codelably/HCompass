import { BaseViewModel } from "@core/base";
import { MainTabItem } from "../models/MainTabItem";

/**
 * @file 主页面 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class MainViewModel extends BaseViewModel {
  /**
   * 当前选中的页面索引
   */
  @Trace
  currentPageIndex: number = 0;
  /**
   * 底部 Tab 配置
   */
  readonly tabItems: Array<MainTabItem> = [
    { title: $r("app.string.core"), icon: $r("app.media.ic_hardware") },
    { title: $r("app.string.navigation"), icon: $r("app.media.ic_route") },
    { title: $r("app.string.expand"), icon: $r("app.media.ic_expand") },
    { title: $r("app.string.about"), icon: $r("app.media.ic_team") }
  ];

  /**
   * 更新当前页面索引
   * @param {number} index - 目标页面索引
   * @returns {void} 无返回值
   */
  updateCurrentPage(index: number): void {
    this.currentPageIndex = index;
  }

  /**
   * 切换 Tab 时更新索引
   * @param {number} index - 选中的索引
   * @returns {void} 无返回值
   */
  handleTabChanged(index: number): void {
    this.updateCurrentPage(index);
  }
}
