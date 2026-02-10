import { IBestPullRefresh } from "@core/ibestui";

/**
 * @file 刷新布局组件（基于 IBestPullRefresh）
 * @author Joker.X
 */
@ComponentV2
export struct RefreshLayout {
  /**
   * 是否处于加载状态
   */
  @Param
  loading: boolean = false;
  /**
   * 是否启用上滑加载
   */
  @Param
  isEnableSlideUp: boolean = true;
  /**
   * 列表/网格使用的 scroller
   */
  @Param
  scroller: Scroller = new Scroller();
  /**
   * 刷新回调
   */
  @Param
  onRefresh: (direction: "pull" | "slideUp") => void = () => {
  };
  /**
   * 刷新容器内容
   */
  @Require
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染刷新布局
   * @returns {void} 无返回值
   */
  build() {
    IBestPullRefresh({
      loading: this.loading,
      scroller: this.scroller,
      isEnableSlideUp: this.isEnableSlideUp,
      defaultContent: (): void => {
        if (this.content) {
          this.content();
        }
      },
      onRefresh: (direction: "pull" | "slideUp"): void => this.onRefresh(direction)
    });
  }
}
