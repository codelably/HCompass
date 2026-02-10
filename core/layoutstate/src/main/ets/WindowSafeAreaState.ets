import { AppStorageV2 } from "@kit.ArkUI";
import { SafeAreaInsets } from "./model/SafeAreaInsets";

/**
 * @file 窗口安全区状态，用于沉浸式布局的避让区域
 * @author Joker.X
 */

/**
 * AppStorageV2 键名
 */
export const WINDOW_SAFE_AREA_STATE_KEY: string = "window_safe_area_state";

/**
 * 全局窗口安全区状态
 */
@ObservedV2
export class WindowSafeAreaState {
  /**
   * 顶部安全区高度（vp）
   */
  @Trace
  topInset: number = 0;
  /**
   * 左侧安全区宽度（vp）
   */
  @Trace
  leftInset: number = 0;
  /**
   * 底部安全区高度（vp）
   */
  @Trace
  bottomInset: number = 0;
  /**
   * 右侧安全区宽度（vp）
   */
  @Trace
  rightInset: number = 0;

  /**
   * 更新安全区数据
   * @param {number} topInset - 顶部安全区高度（vp）
   * @param {number} leftInset - 左侧安全区宽度（vp）
   * @param {number} bottomInset - 底部安全区高度（vp）
   * @param {number} rightInset - 右侧安全区宽度（vp）
   * @returns {void} 无返回值
   * @example
  * state.updateSafeArea(24, 0, 32, 0);
   */
  updateSafeArea(topInset: number, leftInset: number, bottomInset: number, rightInset: number): void {
    this.topInset = topInset;
    this.leftInset = leftInset;
    this.bottomInset = bottomInset;
    this.rightInset = rightInset;
  }

  /**
   * 更新安全区数据（结构体方式）
   * @param {SafeAreaInsets} insets - 安全区数据
   * @returns {void} 无返回值
   * @example
  * state.updateSafeAreaByInsets({ top: 24, left: 0, bottom: 32, right: 0 });
   */
  updateSafeAreaByInsets(insets: SafeAreaInsets): void {
    this.updateSafeArea(insets.top, insets.left, insets.bottom, insets.right);
  }
}

/**
 * 获取全局窗口安全区状态实例；若不存在则创建
 * @returns {WindowSafeAreaState} 全局窗口安全区状态
 * @example
* const state = getWindowSafeAreaState();
 */
export function getWindowSafeAreaState(): WindowSafeAreaState {
  return AppStorageV2.connect<WindowSafeAreaState>(
    WindowSafeAreaState,
    WINDOW_SAFE_AREA_STATE_KEY,
    () => new WindowSafeAreaState()
  )!;
}
