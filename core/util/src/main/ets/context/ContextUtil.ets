import { UIContext } from "@ohos.arkui.UIContext";
import common from "@ohos.app.ability.common";
import { window } from "@kit.ArkUI";

/**
 * @file Context 获取工具
 * @author JunBin.Yang
 */

export class ContextUtil {
  private static context: common.UIAbilityContext;

  /**
   * 在 UIAbility 的 onCreate 方法中获取 UIAbilityContext
   */
  static init(context: common.UIAbilityContext) {
    ContextUtil.context = context;
  }

  /**
   * 获取 UIAbility 组件的上下文
   * @returns {common.UIAbilityContext}
   */
  static getUIAbilityCtx(): common.UIAbilityContext {
    return ContextUtil.context
  }

  /**
   * 获取 UIContext
   * @param {window.Window} win 获取 UIContext 的目标窗口
   * @returns {UIContext}
   */
  static getUICtx(win?: window.Window): UIContext {
    if(!win) win = ContextUtil.context.windowStage.getMainWindowSync();
    return win.getUIContext();
  }

  /**
   * 获取应用级别的上下文的能力
   * @returns {common.ApplicationContext}
   */
  static getAppCtx(): common.ApplicationContext {
    return ContextUtil.context.getApplicationContext();
  }

  /**
   * 获得当前元能力的 Context
   * @returns {common.Context | undefined} hostContext；获取失败返回 undefined
   */
  static getHostCtx(): common.Context | undefined {
    return ContextUtil.getUICtx().getHostContext();
  }
}
