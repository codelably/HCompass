/**
 * @file 通用图标组件
 * @author Joker.X
 */
@ComponentV2
export struct CommonIcon {
  /**
   * 图标资源
   */
  @Param
  icon: ResourceStr = "";
  /**
   * 图标大小（单位：vp）
   */
  @Param
  iconSize: number = 24;
  /**
   * 图标颜色（不传则不着色）
   */
  @Param
  tintColor: ResourceColor | undefined = undefined;
  /**
   * 点击回调
   */
  @Param
  onTap: (() => void) | undefined = undefined;

  /**
   * 构建通用图标
   * @returns {void} 无返回值
   */
  build(): void {
    if (this.tintColor !== undefined) {
      if (this.onTap) {
        Image(this.icon)
          .width(this.iconSize)
          .height(this.iconSize)
          .fillColor(this.tintColor)
          .onClick((): void => this.handleTap());
      } else {
        Image(this.icon)
          .width(this.iconSize)
          .height(this.iconSize)
          .fillColor(this.tintColor);
      }
    } else {
      if (this.onTap) {
        Image(this.icon)
          .width(this.iconSize)
          .height(this.iconSize)
          .onClick((): void => this.handleTap());
      } else {
        Image(this.icon)
          .width(this.iconSize)
          .height(this.iconSize);
      }
    }
  }

  /**
   * 处理点击事件
   * @returns {void} 无返回值
   */
  private handleTap(): void {
    if (this.onTap) {
      this.onTap();
    }
  }
}
