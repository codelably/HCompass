import { P100, SpaceVerticalMedium } from "@core/designsystem";
import { Loading } from "./Loading";

/**
 * @file 页面级 Loading 组件
 * @author Joker.X
 */

@ComponentV2
export struct PageLoading {
  /**
   * 加载提示文案
   */
  @Param
  text: string = "加载中...";

  /**
   * 构建页面级 Loading 视图
   * @returns {void} 无返回值
   */
  build(): void {
    Column() {
      Loading();
      SpaceVerticalMedium();
      Text(this.text);
    }
    .width(P100)
    .height(P100)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center);
  }
}
