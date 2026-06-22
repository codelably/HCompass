import { IBestToast } from "@core/ibestui";

/**
 * @file Toast 工具类，封装 IBestToast 常用能力
 * @author Joker.X
 */
export class ToastUtils {
  /**
   * 显示普通 Toast
   * @param {string | ResourceStr} message - 提示内容
   * @returns {void} 无返回值
   */
  static show(message: string | ResourceStr): void {
    IBestToast.show(message);
  }

  /**
   * 显示成功提示
   * @param {string | ResourceStr} message - 提示内容
   * @returns {void} 无返回值
   */
  static showSuccess(message: string | ResourceStr): void {
    IBestToast.show({
      type: "success",
      message: message
    });
  }

  /**
   * 显示失败提示
   * @param {string | ResourceStr} message - 提示内容
   * @returns {void} 无返回值
   */
  static showError(message: string | ResourceStr): void {
    IBestToast.show({
      type: "fail",
      message: message
    });
  }

  /**
   * 显示警告提示
   * @param {string | ResourceStr} message - 提示内容
   * @returns {void} 无返回值
   */
  static showWarning(message: string | ResourceStr): void {
    IBestToast.show({
      type: "warning",
      message: message
    });
  }

  /**
   * 显示加载中提示
   * @returns {void} 无返回值
   */
  static showLoading(): void {
    IBestToast.showLoading();
  }

  /**
   * 显示 Spinner 加载提示
   * @param {string | ResourceStr} message - 提示内容
   * @returns {void} 无返回值
   */
  static showSpinnerLoading(message: string | ResourceStr): void {
    IBestToast.show({
      type: "loading",
      loadingType: "spinner",
      message: message
    });
  }

  /**
   * 显示带图标的 Toast
   * @param {string | ResourceStr} message - 提示内容
   * @param {Resource | string} icon - 图标资源或网络地址
   * @returns {void} 无返回值
   */
  static showIcon(message: string | ResourceStr, icon: Resource | string): void {
    IBestToast.show({
      icon: icon,
      iconWidth: 50,
      message: message
    });
  }

  /**
   * 显示顶部 Toast
   * @param {string | ResourceStr} message - 提示内容
   * @returns {void} 无返回值
   */
  static showTop(message: string | ResourceStr): void {
    IBestToast.show({
      position: "top",
      offsetY: "20%",
      message: message
    });
  }

  /**
   * 显示底部 Toast
   * @param {string | ResourceStr} message - 提示内容
   * @returns {void} 无返回值
   */
  static showBottom(message: string | ResourceStr): void {
    IBestToast.show({
      position: "bottom",
      offsetY: "-20%",
      message: message
    });
  }

  /**
   * 显示强制截断换行 Toast
   * @param {string | ResourceStr} message - 提示内容
   * @returns {void} 无返回值
   */
  static showBreakAll(message: string | ResourceStr): void {
    IBestToast.show({
      wordBreak: "break-all",
      message: message
    });
  }

  /**
   * 显示按词换行 Toast
   * @param {ResourceStr} message - 提示内容
   * @returns {void} 无返回值
   */
  static showBreakWord(message: string | ResourceStr): void {
    IBestToast.show({
      wordBreak: "break-word",
      message: message
    });
  }

  /**
   * 隐藏 Toast
   * @returns {void} 无返回值
   */
  static hide(): void {
    IBestToast.hide();
  }
}
