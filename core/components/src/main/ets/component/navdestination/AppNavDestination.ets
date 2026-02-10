import { BaseViewModel } from "@core/base";
import { getWindowSafeAreaState, WindowSafeAreaState } from "@core/layoutstate";

/**
 * @file 通用导航容器：统一 NavDestination 与 ViewModel 生命周期转发
 * @author Joker.X
 */
@ComponentV2
export struct AppNavDestination {
  /**
   * 传入的视图模型实例（必传）
   */
  @Param
  @Require
  viewModel: BaseViewModel;
  /**
   * 业务内容渲染
   */
  @BuilderParam
  content: CustomBuilder;
  /**
   * 是否启用安全区（默认开启）
   */
  @Param
  safeAreaEnabled: boolean = true;
  /**
   * 是否隐藏标题栏（默认不隐藏）
   */
  @Param
  hideTitleBar: boolean = false;
  /**
   * 标题内容（可选）
   */
  @Param
  title: string | CustomBuilder | NavDestinationCommonTitle | NavDestinationCustomTitle | Resource = "";
  /**
   * 标题栏配置
   */
  @Param
  titleOptions: NavigationTitleOptions = {
    backgroundColor: $r("app.color.bg_grey")
  };
  /**
   * 导航栏菜单内容（可选）
   */
  @Param
  menus: Array<NavigationMenuItem> | CustomBuilder = [];
  /**
   * 导航栏菜单配置（可选）
   */
  @Param
  menuOptions: NavigationMenuOptions | undefined = undefined;
  /**
   * 页面背景色
   */
  @Param
  pageBackgroundColor: ResourceColor | ColorMetrics = $r("app.color.bg_grey");
  /**
   * 当前窗口安全区状态（可外部传入，默认内部获取）
   */
  @Param
  windowSafeAreaState: WindowSafeAreaState = getWindowSafeAreaState();
  /**
   * 自定义页面内边距（默认使用安全区）
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;

  /**
   * 页面出现时的生命周期回调
   * @returns {void} 无返回值
   */
  aboutToAppear(): void {
    this.viewModel.aboutToAppear();
  }

  /**
   * 页面隐藏时的生命周期回调
   * @returns {void} 无返回值
   */
  aboutToDisappear(): void {
    this.viewModel.aboutToDisappear();
  }

  /**
   * 页面销毁时的生命周期回调
   * @returns {void} 无返回值
   */
  aboutToBeDeleted(): void {
    this.viewModel.aboutToBeDeleted();
  }

  /**
   * 组件构建完成（API 12+）
   * @returns {void} 无返回值
   */
  onDidBuild(): void {
    this.viewModel.onDidBuild();
  }

  /**
   * 组件即将回收
   * @returns {void} 无返回值
   */
  aboutToRecycle(): void {
    this.viewModel.aboutToRecycle();
  }

  /**
   * 主题即将应用
   * @param {Theme} theme - 主题对象
   * @returns {void} 无返回值
   */
  onWillApplyTheme(theme: Theme): void {
    this.viewModel.onWillApplyTheme(theme);
  }

  /**
   * 渲染通用 NavDestination
   * @returns {void} 无返回值
   */
  build() {
    NavDestination() {
      if (this.content) {
        this.content();
      }
    }
    .title(this.title, this.titleOptions)
    .hideTitleBar(this.hideTitleBar)
    .menus(this.menus, this.menuOptions)
    .onShown((reason: VisibilityChangeReason) => {
      this.viewModel.onShown(reason);
    })
    .onHidden((reason: VisibilityChangeReason) => {
      this.viewModel.onHidden(reason);
    })
    .backgroundColor(this.pageBackgroundColor)
    .padding(this.paddingValue ?? (this.safeAreaEnabled ? this.getSafeAreaPadding() : 0));
  }

  /**
   * 获取安全区内边距
   * @returns {Padding} 安全区内边距
   */
  private getSafeAreaPadding(): Padding {
    return {
      top: this.windowSafeAreaState.topInset,
      left: this.windowSafeAreaState.leftInset,
      bottom: this.windowSafeAreaState.bottomInset,
      right: this.windowSafeAreaState.rightInset
    };
  }
}
