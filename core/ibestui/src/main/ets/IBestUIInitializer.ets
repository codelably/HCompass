import common from "@ohos.app.ability.common";
import { window } from "@kit.ArkUI";
import { IBestInit, IBestSetUIBaseStyle } from "@ibestservices/ibest-ui-v2";

/**
 * @file IBest UI 初始化管理器
 * @author Joker.X
 */
export class IBestUIInitializer {
  /**
   * 初始化 IBest UI 组件库
   * @param {window.WindowStage} windowStage - 窗口阶段
   * @param {common.UIAbilityContext} context - UIAbility 上下文
   * @returns {void} 无返回值
   */
  static initIBestUI(windowStage: window.WindowStage, context: common.UIAbilityContext): void {
    IBestInit(windowStage, context);
    IBestUIInitializer.setIBestUIBaseStyle();
  }

  /**
   * 设置 IBest UI 组件库基础样式
   * @returns {void} 无返回值
   */
  static setIBestUIBaseStyle(): void {
    IBestSetUIBaseStyle({
      primary: $r("app.color.primary"),
      success: $r("app.color.success"),
      warning: $r("app.color.warning"),
      danger: $r("app.color.danger"),
    });
  }
}
