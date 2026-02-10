import { Empty } from "./Empty";

/**
 * @file 数据缺省页（无数据）
 * @author Joker.X
 */
@ComponentV2
export struct EmptyData {
  /**
   * 构建数据缺省页视图
   * @returns {void} 无返回值
   */
  build(): void {
    Empty({
      description: "暂无数据",
      imageRes: $r("app.media.ic_empty_data")
    });
  }
}
