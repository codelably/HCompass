import { BaseViewModel } from "@core/base";
import { DemoCounterState, getDemoCounterState } from "@shared/state";

/**
 * @file 状态管理示例页 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class StateManagementViewModel extends BaseViewModel {
  /**
   * 计数器状态
   */
  @Trace
  counterState: DemoCounterState = getDemoCounterState();

  /**
   * 计数加一
   * @returns {void} 无返回值
   */
  increment(): void {
    this.counterState.increment();
  }

  /**
   * 计数减一
   * @returns {void} 无返回值
   */
  decrement(): void {
    this.counterState.decrement();
  }

  /**
   * 重置计数
   * @returns {void} 无返回值
   */
  reset(): void {
    this.counterState.reset();
  }
}
