/**
 * @file 通用基础视图模型，提供生命周期钩子
 * @author Joker.X
 */
@ObservedV2
export class BaseViewModel {
  /**
   * 页面出现前（组件创建后、build 前）
   * @returns {void} 无返回值
   */
  aboutToAppear(): void {
  }

  /**
   * 页面隐藏前
   * @returns {void} 无返回值
   */
  aboutToDisappear(): void {
  }

  /**
   * 组件构建完成（API 12+）
   * @returns {void} 无返回值
   */
  onDidBuild(): void {
  }

  /**
   * 组件即将回收
   * @returns {void} 无返回值
   */
  aboutToRecycle(): void {
  }

  /**
   * 主题即将应用
   * @param {Theme} theme - 主题对象
   * @returns {void} 无返回值
   */
  onWillApplyTheme(theme: Theme): void {
  }

  /**
   * 生命周期：销毁
   * @returns {void} 无返回值
   */
  aboutToBeDeleted(): void {
  }

  /**
   * 页面显示完成 - 来自 NavDestination
   * @param {VisibilityChangeReason} reason - 可见性变化原因
   * @returns {void} 无返回值
   */
  onShown(reason: VisibilityChangeReason): void {
  }

  /**
   * 页面隐藏完成 - 来自 NavDestination
   * @param {VisibilityChangeReason} reason - 可见性变化原因
   * @returns {void} 无返回值
   */
  onHidden(reason: VisibilityChangeReason): void {
  }
}
