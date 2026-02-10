import { Empty } from "./Empty";

/**
 * @file 网络缺省页
 * @author Joker.X
 */
@ComponentV2
export struct EmptyNetwork {
  /**
   * 描述文案
   */
  @Param
  description: ResourceStr = "网络异常";
  /**
   * 操作按钮文案（仅当 onAction 存在时展示）
   */
  @Param
  actionText: ResourceStr = "重试";
  /**
   * 操作按钮点击回调（不传则不展示按钮）
   */
  @Param
  onAction: (() => void) | undefined = undefined;

  /**
   * 构建网络缺省页视图
   * @returns {void} 无返回值
   */
  build(): void {
    Empty({
      description: this.description,
      imageRes: $r("app.media.ic_empty_network"),
      actionText: this.actionText,
      onAction: this.onAction
    });
  }
}
