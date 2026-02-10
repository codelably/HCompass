import { display, window } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { BreakpointState, SafeAreaInsets, WindowSafeAreaState } from "@core/layoutstate";
import { Context } from "@kit.AbilityKit";

/**
 * @file 窗口能力适配器：负责沉浸式、安全区与断点监听，供 EntryViewModel 复用
 * @author Joker.X
 */

/**
 * 窗口尺寸变化数据
 * @property {number | undefined} width - 当前窗口宽度（px），可能为空
 */
interface WindowSizeChangeData {
  width?: number;
}

/**
 * 安全区变化数据
 * @property {window.AvoidAreaType} type - 变化类型（系统栏/导航栏）
 * @property {window.AvoidArea} area - 变化后的避让区域数据
 */
interface AvoidAreaChangeData {
  type: window.AvoidAreaType;
  area: window.AvoidArea;
}

export class WindowAdapter {
  /**
   * 当前窗口实例
   */
  private windowClass?: window.Window;
  /**
   * 全局安全区状态（vp）
   */
  private readonly safeAreaState: WindowSafeAreaState;
  /**
   * 全局断点状态
   */
  private readonly breakpointState: BreakpointState;
  /**
   * 本地缓存的安全区数据（vp），用于对比变化
   */
  private currentSafeArea: SafeAreaInsets = {
    top: 0,
    left: 0,
    bottom: 0,
    right: 0
  };
  /**
   * 安全区变化监听处理器
   */
  private avoidAreaChangeHandler?: (data: AvoidAreaChangeData) => void;
  /**
   * 窗口尺寸变化监听处理器
   */
  private windowSizeChangeHandler?: (data: WindowSizeChangeData) => void;

  constructor(safeAreaState: WindowSafeAreaState, breakpointState: BreakpointState) {
    this.safeAreaState = safeAreaState;
    this.breakpointState = breakpointState;
  }

  /**
   * 初始化窗口能力（沉浸式、安全区、断点）
   * @param {Context} context - 组件上下文
   * @returns {void} 无返回值
   */
  init(context: Context): void {
    window.getLastWindow(context, (err: BusinessError, data) => {
      const errCode: number = err.code;
      if (errCode) {
        console.error(`Failed to obtain the top window. Cause code: ${err.code}, message: ${err.message}`);
        return;
      }
      this.windowClass = data;
      // 开启沉浸式全屏布局
      this.initImmersiveWindow(data);
      // 监听安全区变化并同步到全局状态
      this.initSafeAreaObserver(data);
      // 监听窗口宽度变化并更新断点
      this.initBreakpointObserver(data);
    });
  }

  /**
   * 初始化沉浸式窗口
   * @param {window.Window} windowClass - 当前窗口
   * @returns {void} 无返回值
   */
  private initImmersiveWindow(windowClass: window.Window): void {
    const isLayoutFullScreen: boolean = true;
    windowClass.setWindowLayoutFullScreen(isLayoutFullScreen).then(() => {
      console.info("Succeeded in setting the window layout to full-screen mode.");
    }).catch((err: BusinessError) => {
      console.error(`Failed to set the window layout to full-screen mode. Cause: ${JSON.stringify(err)}`);
    });
  }

  /**
   * 初始化安全区监听
   * @param {window.Window} windowClass - 当前窗口
   * @returns {void} 无返回值
   */
  private initSafeAreaObserver(windowClass: window.Window): void {
    const displayId = this.getDisplayId();
    if (displayId === undefined) {
      console.error("Failed to obtain displayId for safe area.");
      return;
    }
    const navigationArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    const systemArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    const topInset = this.pxToVp(systemArea.topRect.height ?? 0, displayId);
    const leftInset = this.pxToVp(systemArea.leftRect?.width ?? 0, displayId);
    const bottomInset = this.pxToVp(navigationArea.bottomRect.height ?? 0, displayId);
    const rightInset = this.pxToVp(systemArea.rightRect?.width ?? 0, displayId);
    this.updateSafeArea({
      top: topInset,
      left: leftInset,
      bottom: bottomInset,
      right: rightInset
    });

    this.avoidAreaChangeHandler = (data) => {
      if (!this.windowClass) {
        return;
      }
      const latestDisplayId = this.getDisplayId();
      if (latestDisplayId === undefined) {
        return;
      }
      const newInsets: SafeAreaInsets = {
        top: this.currentSafeArea.top,
        left: this.currentSafeArea.left,
        bottom: this.currentSafeArea.bottom,
        right: this.currentSafeArea.right
      };
      if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
        newInsets.top = this.pxToVp(data.area.topRect.height ?? 0, latestDisplayId);
        newInsets.left = this.pxToVp(data.area.leftRect?.width ?? 0, latestDisplayId);
        newInsets.right = this.pxToVp(data.area.rightRect?.width ?? 0, latestDisplayId);
      } else if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        newInsets.bottom = this.pxToVp(data.area.bottomRect.height ?? 0, latestDisplayId);
      }
      this.updateSafeArea(newInsets);
    };
    windowClass.on("avoidAreaChange", this.avoidAreaChangeHandler);
  }

  /**
   * 初始化断点监听
   * @param {window.Window} windowClass - 当前窗口
   * @returns {void} 无返回值
   */
  private initBreakpointObserver(windowClass: window.Window): void {
    const initialWidth = windowClass.getWindowProperties().windowRect.width;
    if (initialWidth !== undefined) {
      this.updateBreakpoint(initialWidth);
    }
    this.windowSizeChangeHandler = (windowSize) => {
      if (windowSize.width !== undefined) {
        this.updateBreakpoint(windowSize.width);
      }
    };
    windowClass.on("windowSizeChange", this.windowSizeChangeHandler);
  }

  /**
   * 更新安全区状态
   * @param {SafeAreaInsets} insets - 安全区数据（vp）
   * @returns {void} 无返回值
   */
  private updateSafeArea(insets: SafeAreaInsets): void {
    if (
      insets.top === this.currentSafeArea.top
        && insets.left === this.currentSafeArea.left
        && insets.bottom === this.currentSafeArea.bottom
        && insets.right === this.currentSafeArea.right
    ) {
      return;
    }
    this.currentSafeArea = insets;
    this.safeAreaState.updateSafeAreaByInsets(insets);
  }

  /**
   * 更新断点状态
   * @param {number} windowWidthPx - 窗口宽度（px）
   * @returns {void} 无返回值
   */
  private updateBreakpoint(windowWidthPx: number): void {
    if (!this.windowClass) {
      return;
    }
    const displayId = this.getDisplayId();
    if (displayId === undefined) {
      console.error("Failed to obtain displayId for breakpoint.");
      return;
    }
    const windowWidthVp = this.pxToVp(windowWidthPx, displayId);
    this.breakpointState.updateByWidth(windowWidthVp);
  }

  /**
   * 像素转 vp，失败时回退为原值
   * @param {number} valuePx - 像素值
   * @param {number} displayId - Display ID
   * @returns {number} vp 值
   */
  private pxToVp(valuePx: number, displayId: number): number {
    try {
      const density = display.getDisplayByIdSync(displayId).densityPixels;
      return valuePx / density;
    } catch (err) {
      console.error(`getDisplayByIdSync failed: ${JSON.stringify(err)}`);
      return valuePx;
    }
  }

  /**
   * 获取当前窗口的 displayId
   * @returns {number | undefined} displayId
   */
  private getDisplayId(): number | undefined {
    return this.windowClass?.getWindowProperties().displayId;
  }

  /**
   * 释放窗口监听
   * @returns {void} 无返回值
   */
  dispose(): void {
    if (!this.windowClass) {
      return;
    }
    if (this.avoidAreaChangeHandler) {
      this.windowClass.off("avoidAreaChange", this.avoidAreaChangeHandler);
    }
    if (this.windowSizeChangeHandler) {
      this.windowClass.off("windowSizeChange", this.windowSizeChangeHandler);
    }
  }
}
