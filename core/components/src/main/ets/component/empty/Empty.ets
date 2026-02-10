import { IBestButton, IBestEmpty } from "@core/ibestui";
import { P100, P70, SpaceVerticalMedium } from "@core/designsystem";

/**
 * @file 通用缺省页组件（基于 IBestEmpty 封装）
 * @author Joker.X
 */
@ComponentV2
export struct Empty {
  /**
   * 描述文案
   */
  @Param
  description: ResourceStr = "暂无内容";
  /**
   * 占位图资源
   */
  @Param
  @Require
  imageRes: ResourceStr = "";
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
   * 构建缺省页视图
   * @returns {void} 无返回值
   */
  build(): void {
    Column() {
      IBestEmpty({
        description: this.description,
        defaultBuilder: () => this.buildAction(),
        emptyImgBuilder: () => this.buildImage()
      });
    }
    .width(P100)
    .height(P100)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center);
  }

  /**
   * 构建操作按钮
   * @returns {void} 无返回值
   */
  @Builder
  private buildAction(): void {
    if (this.onAction) {

      SpaceVerticalMedium();

      IBestButton({
        text: this.actionText,
        type: "primary",
        plain: true,
        hairline: true,
        round: true,
        btnWidth: P70
      })
        .onClick(() => {
          if (this.onAction) {
            this.onAction();
          }
        });
    }
  }

  /**
   * 构建占位图
   * @returns {void} 无返回值
   */
  @Builder
  private buildImage(): void {
    Image(this.imageRes)
      .fillColor($r("app.color.empty_tint"))
      .height(140);
  }
}
