import { ColumnCenter } from "@core/designsystem";
import { AppNavDestination, BaseNetWorkView } from "@core/components";
import NetworkDemoViewModel from "../viewmodel/NetworkDemoViewModel";

/**
 * @file Network Demo 示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct NetworkDemoPage {
  /**
   * Network Demo 示例页 ViewModel
   */
  @Local
  private vm: NetworkDemoViewModel = new NetworkDemoViewModel();

  /**
   * 构建 Network Demo 示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_base_network_title"),
      viewModel: this.vm
    }) {
      BaseNetWorkView({
        uiState: this.vm.uiState,
        onRetry: (): void => this.vm.retryRequest(),
        content: (): void => this.NetworkDemoContent()
      });
    }
  }

  /**
   * 构建网络示例内容
   * @returns {void} 无返回值
   */
  @Builder
  private NetworkDemoContent() {
    ColumnCenter() {
      Text(this.vm.data?.title ?? "")
      Text(this.vm.data?.subTitle ?? "")
    }
  }
}
