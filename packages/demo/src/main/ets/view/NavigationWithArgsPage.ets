import { ColumnCenter } from "@core/designsystem";
import { AppNavDestination } from "@core/components";
import NavigationWithArgsViewModel from "../viewmodel/NavigationWithArgsViewModel";

/**
 * @file 带参跳转示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct NavigationWithArgsPage {
  /**
   * 带参跳转示例页 ViewModel
   */
  @Local
  private vm: NavigationWithArgsViewModel = new NavigationWithArgsViewModel();

  /**
   * 构建带参跳转示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_navigation_with_args_title"),
      viewModel: this.vm
    }) {
      this.NavigationWithArgsContent();
    }
  }

  /**
   * 带参跳转示例页内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private NavigationWithArgsContent() {
    ColumnCenter() {
      Text(this.vm.routeParams?.goodsId.toString() ?? $r("app.string.demo_navigation_with_args_value_empty"));
      Text(this.vm.routeParams?.goodsName ?? $r("app.string.demo_navigation_with_args_value_empty"));
    }
  }
}
