import { BaseNetWorkListUiState } from "@core/base";
import { EmptyData } from "../empty/EmptyData";
import { EmptyNetwork } from "../empty/EmptyNetwork";
import { PageLoading } from "../loading/PageLoading";

/**
 * @file 网络列表通用视图组件
 * @author Joker.X
 */
@ComponentV2
export struct BaseNetWorkListView {
  /**
   * 当前列表请求 UI 状态
   */
  @Param
  uiState: BaseNetWorkListUiState = BaseNetWorkListUiState.LOADING;
  /**
   * 错误状态下的重试回调
   */
  @Param
  onRetry: () => void = () => {
  };
  /**
   * 自定义加载内容
   */
  @BuilderParam
  loadingBuilder: CustomBuilder;
  /**
   * 自定义错误内容
   */
  @BuilderParam
  errorBuilder: CustomBuilder;
  /**
   * 自定义空数据内容
   */
  @BuilderParam
  emptyBuilder: CustomBuilder;
  /**
   * 成功状态下渲染内容
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 默认加载视图
   * @returns {void} 无返回值
   */
  @Builder
  buildDefaultLoading(): void {
    PageLoading();
  }

  /**
   * 默认错误视图
   * @returns {void} 无返回值
   */
  @Builder
  buildDefaultError(): void {
    EmptyNetwork({
      onAction: this.onRetry
    });
  }

  /**
   * 默认空数据视图
   * @returns {void} 无返回值
   */
  @Builder
  buildDefaultEmpty(): void {
    EmptyData();
  }

  /**
   * 渲染列表请求状态视图
   * @returns {void} 无返回值
   */
  build() {
    Stack() {
      Column() {
        if (this.loadingBuilder) {
          this.loadingBuilder();
        } else {
          this.buildDefaultLoading();
        }
      }
      .opacity(this.uiState === BaseNetWorkListUiState.LOADING ? 1 : 0)
      .animation({ duration: 200, curve: Curve.EaseInOut });

      Column() {
        if (this.errorBuilder) {
          this.errorBuilder();
        } else {
          this.buildDefaultError();
        }
      }
      .opacity(this.uiState === BaseNetWorkListUiState.ERROR ? 1 : 0)
      .animation({ duration: 200, curve: Curve.EaseInOut });

      Column() {
        if (this.emptyBuilder) {
          this.emptyBuilder();
        } else {
          this.buildDefaultEmpty();
        }
      }
      .opacity(this.uiState === BaseNetWorkListUiState.EMPTY ? 1 : 0)
      .animation({ duration: 200, curve: Curve.EaseInOut });

      Column() {
        if (this.content) {
          this.content();
        }
      }
      .opacity(this.uiState === BaseNetWorkListUiState.LOADING
        || this.uiState === BaseNetWorkListUiState.ERROR
        || this.uiState === BaseNetWorkListUiState.EMPTY ? 0 : 1)
      .animation({ duration: 200, curve: Curve.EaseInOut });
    }
  }
}
