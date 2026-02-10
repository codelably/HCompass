/**
 * @file Loading 组件
 * @author Joker.X
 */
@ComponentV2
export struct Loading {
  @Param
  loadSize: number = 40;

  /**
   * 构建 Loading 视图
   * @returns void
   */
  build(): void {
    LoadingProgress()
      .width(this.loadSize);
  }
}
