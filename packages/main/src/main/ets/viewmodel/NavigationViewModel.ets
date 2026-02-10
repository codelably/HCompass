import { BaseViewModel } from "@core/base";
import { getContainer } from "@core/di";
import { IDemoNavSvc, IUserNavSvc, USER_NAV_SVC_KEY, DEMO_NAV_SVC_KEY } from "@shared/contracts";
import { DemoNavResult } from "@shared/types";
import { NavigationCardItem } from "../models/NavigationCardItem";

/**
 * @file 导航页面 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class NavigationViewModel extends BaseViewModel {
  /**
   * 结果回传标题
   */
  @Trace
  resultTitle: string = "";
  /**
   * 结果回传说明
   */
  @Trace
  resultDescription: string = "";
  /**
   * 是否存在结果回传
   */
  @Trace
  hasResult: boolean = false;
  /**
   * 导航模块卡片数据
   */
  @Trace
  readonly cards: NavigationCardItem[] = [
    {
      title: $r("app.string.main_navigation_with_args_title"),
      description: $r("app.string.main_navigation_with_args_desc"),
      onClick: () => {
        const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
        DemoNavigator?.toNavigationWithArgs(10001, $r("app.string.main_navigation_goods_name"));
      }
    },
    {
      title: $r("app.string.main_navigation_result_title"),
      description: $r("app.string.main_navigation_result_desc"),
      onClick: (): void => this.requestNavigationResult()
    },
    {
      title: $r("app.string.main_navigation_intercept_title"),
      description: $r("app.string.main_navigation_intercept_desc"),
      onClick: () => {
        const UserNavigator = getContainer().tryResolve<IUserNavSvc>(USER_NAV_SVC_KEY);
        UserNavigator?.toProfile();
      }
    }
  ];

  /**
   * 发起结果回传跳转
   * @returns {void} 无返回值
   */
  requestNavigationResult(): void {
    const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
    DemoNavigator?.toNavigationResult()
      .then((result?: DemoNavResult): void => {
        const title: string = result?.title?.trim() ?? "";
        const description: string = result?.description?.trim() ?? "";
        if (title.length === 0 && description.length === 0) {
          this.clearResult();
          return;
        }
        this.resultTitle = title;
        this.resultDescription = description;
        this.hasResult = true;
      });
  }

  /**
   * 清空回传结果
   * @returns {void} 无返回值
   */
  private clearResult(): void {
    this.resultTitle = "";
    this.resultDescription = "";
    this.hasResult = false;
  }

  /**
   * 是否展示结果区域
   * @returns {boolean} 是否展示
   */
  shouldShowResult(): boolean {
    return this.hasResultTitle() || this.hasResultDesc();
  }

  /**
   * 是否存在结果标题
   * @returns {boolean} 是否存在
   */
  hasResultTitle(): boolean {
    return this.resultTitle.length > 0;
  }

  /**
   * 是否存在结果说明
   * @returns {boolean} 是否存在
   */
  hasResultDesc(): boolean {
    return this.resultDescription.length > 0;
  }
}
