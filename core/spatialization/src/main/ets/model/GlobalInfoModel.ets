/**
 * @file 全局设备窗口信息模型
 * @author JunBin.Yang
 */

@ObservedV2
export class GlobalInfoModel {
  @Trace public foldExpanded: boolean = false;
  @Trace public widthBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Trace public heightBreakpoint: HeightBreakpoint = HeightBreakpoint.HEIGHT_SM;
  @Trace public statusBarHeight: number = 0;
  @Trace public naviIndicatorHeight: number = 0;
  @Trace public deviceWidth: number = 0;
  @Trace public deviceHeight: number = 0;
  /** 是否需要动态隐藏底栏（小屏横屏/中屏宽屏场景） */
  public needDynamicHideBar: boolean = false;
  public aspectRatio: number = 0;
}
