import { AppStorageV2 } from "@kit.ArkUI";

/**
 * @file 全局计数器状态（ArkTS V2），提供跨页面共享的响应式状态
 * @author Joker.X
 */

/**
 * AppStorageV2 键名
 */
export const DEMO_COUNTER_KEY: string = "demo_counter_state";

/**
 * 全局计数器状态
 */
@ObservedV2
export class DemoCounterState {
  /**
   * 当前计数
   */
  @Trace
  count: number = 0;

  /**
   * 计数加一（或自定义步长）
   * @param {number} step - 步长，默认 1
   * @returns {void} 无返回值
   * @example
   * getDemoCounterState().increment(); // +1
   */
  increment(step: number = 1): void {
    this.count += step;
  }

  /**
   * 计数减一（或自定义步长）
   * @param {number} step - 步长，默认 1
   * @returns {void} 无返回值
   * @example
   * getDemoCounterState().decrement(); // -1
   */
  decrement(step: number = 1): void {
    if (this.count - step < 0) {
      this.count = 0;
      return;
    }
    this.count -= step;
  }

  /**
   * 重置计数
   * @param {number} resetValue - 重置值，默认 0
   * @returns {void} 无返回值
   * @example
   * getDemoCounterState().reset(); // 归零
   */
  reset(resetValue: number = 0): void {
    this.count = resetValue;
  }
}

/**
 * 获取全局计数器状态实例；若不存在则创建
 * @returns {DemoCounterState} 全局计数器状态
 * @example
 * const state = getDemoCounterState();
 */
export function getDemoCounterState(): DemoCounterState {
  return AppStorageV2.connect<DemoCounterState>(
    DemoCounterState,
    DEMO_COUNTER_KEY,
    () => new DemoCounterState()
  )!;
}
