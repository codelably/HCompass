import { IBestCard, IBestCell } from "@core/ibestui";
import { P100 } from "@core/designsystem";
import { AppNavDestination, BaseNetWorkListView, RefreshLayout } from "@core/components";
import NetworkListDemoViewModel from "../viewmodel/NetworkListDemoViewModel";
import { Goods } from "@shared/types";

/**
 * @file Network List Demo 示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct NetworkListDemoPage {
  /**
   * Network List Demo 示例页 ViewModel
   */
  @Local
  private vm: NetworkListDemoViewModel = new NetworkListDemoViewModel();
  /**
   * 列表滚动控制器
   */
  private listScroller: Scroller = new Scroller();

  /**
   * 构建 Network List Demo 示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_base_network_list_title"),
      viewModel: this.vm
    }) {
      BaseNetWorkListView({
        uiState: this.vm.uiState,
        onRetry: (): void => this.vm.retryRequest(),
        content: (): void => this.NetworkListDemoContent()
      });
    }
  }

  /**
   * 构建网络列表示例内容
   * @returns {void} 无返回值
   */
  @Builder
  private NetworkListDemoContent() {
    RefreshLayout({
      scroller: this.listScroller,
      loading: this.vm.isLoading,
      isEnableSlideUp: this.vm.isEnableSlideUp,
      onRefresh: (direction): void => this.vm.onRefreshDirection(direction),
    }) {
      List({ space: 12, scroller: this.listScroller }) {
        ForEach(this.vm.listData, (item: Goods) => {
          ListItem() {
            this.NetworkListDemoItem(item);
          }
        }, (item: Goods) => `${item.id}`);
      }
      .padding($r("app.float.space_padding_medium"))
      .width(P100)
      .height(P100);
    }
  }

  /**
   * 渲染列表项
   * @param {Goods} item - 列表项数据
   * @returns {void} 无返回值
   */
  @Builder
  private NetworkListDemoItem(item: Goods) {
    IBestCard({ shadowRadius: 0 }) {
      IBestCell({
        title: item.title,
        label: item.subTitle ?? "",
        isLink: false,
        hasBorder: false,
        leftContentWidth: P100
      });
    }
  }
}
