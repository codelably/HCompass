/**
 * @file 窗口尺寸与安全区域管理工具
 * @author JunBin.Yang
 */

import { AppStorageV2, UIContext, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '@core/util';
import { SpatializationConstants, StorageKey } from '../constants/SpatializationConstants';
import { GlobalInfoModel } from '../model/GlobalInfoModel';

const TAG: string = 'WindowUtil';

export class WindowUtil {
  private static windowClass?: window.Window;
  private static uiContext: UIContext;

  /**
   * 初始化窗口信息管理，需在 onWindowStageCreate 加载页面后调用
   * @param windowStage UIAbility 的 windowStage 实例
   */
  public static initialize(windowStage: window.WindowStage): void {
    try {
      WindowUtil.windowClass = windowStage.getMainWindowSync();
      const uiContext: UIContext = WindowUtil.windowClass.getUIContext();
      WindowUtil.uiContext = uiContext;
      AppStorageV2.connect(UIContext, StorageKey.UI_CONTEXT, () => uiContext);
      WindowUtil.registerBreakpoint(WindowUtil.windowClass);
    } catch (err) {
      Logger.error(`WindowUtil initialize failed. Cause: ${(err as BusinessError).message}`, TAG);
    }
  }

  private static getDeviceSize(): void {
    try {
      const properties = WindowUtil.windowClass?.getWindowProperties();
      WindowUtil.setWindowSize(properties?.windowRect);
    } catch (err) {
      Logger.error(`getDeviceSize failed. ${(err as BusinessError).message}`, TAG);
    }
  }

  private static registerBreakpoint(windowClass: window.Window): void {
    try {
      WindowUtil.getDeviceSize();
      const model: GlobalInfoModel =
        AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO, () => new GlobalInfoModel()) ??
          new GlobalInfoModel();

      const systemArea: window.AvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      model.statusBarHeight = WindowUtil.uiContext.px2vp(systemArea?.topRect?.height ?? 0);

      const bottomArea: window.AvoidArea =
        windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      model.naviIndicatorHeight = WindowUtil.uiContext.px2vp(bottomArea?.bottomRect?.height ?? 0);

      AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO, () => model);

      windowClass.on('windowSizeChange', (size: window.Size) => WindowUtil.setWindowSize(size));
      windowClass.on('avoidAreaChange', (opt) => {
        if (opt.type === window.AvoidAreaType.TYPE_SYSTEM ||
          opt.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          WindowUtil.setAvoidArea(opt.type, opt.area);
        }
      });
    } catch (err) {
      Logger.error(`registerBreakpoint failed. ${(err as BusinessError).message}`, TAG);
    }
  }

  public static setAvoidArea(type: window.AvoidAreaType, area: window.AvoidArea): void {
    const model: GlobalInfoModel =
      AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO, () => new GlobalInfoModel()) ??
        new GlobalInfoModel();
    if (type === window.AvoidAreaType.TYPE_SYSTEM) {
      model.statusBarHeight = WindowUtil.uiContext.px2vp(area?.topRect?.height ?? 0);
    } else {
      model.naviIndicatorHeight = WindowUtil.uiContext.px2vp(area?.bottomRect?.height ?? 0);
    }
    AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO, () => model);
  }

  public static setWindowSize(windowSize?: window.Size | window.Rect): void {
    const model: GlobalInfoModel =
      AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO, () => new GlobalInfoModel()) ??
        new GlobalInfoModel();
    if (windowSize) {
      const vpHeight = WindowUtil.uiContext.px2vp(windowSize.height);
      const vpWidth = WindowUtil.uiContext.px2vp(windowSize.width);
      model.deviceHeight = vpHeight;
      model.deviceWidth = vpWidth;
      if (vpHeight > 0) {
        model.aspectRatio = vpWidth / vpHeight;
      }
    }
    model.widthBreakpoint = WindowUtil.uiContext.getWindowWidthBreakpoint();
    model.heightBreakpoint = WindowUtil.uiContext.getWindowHeightBreakpoint();
    model.needDynamicHideBar =
      (model.widthBreakpoint === WidthBreakpoint.WIDTH_SM &&
        model.aspectRatio > SpatializationConstants.ASPECT_SQUARE_PORTRAIT) ||
      (model.widthBreakpoint === WidthBreakpoint.WIDTH_MD &&
        model.aspectRatio > SpatializationConstants.ASPECT_LANDSCAPE_SQUARE);
    AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO, () => model);
  }
}
