import { BaseViewModel } from "@core/base";
import { Want } from "@kit.AbilityKit";
import common from "@ohos.app.ability.common";
import { ContextUtil } from "@core/util";
import { AboutLinkItem } from "../models/AboutLinkItem";

/**
 * @file 关于页面 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class AboutViewModel extends BaseViewModel {
  /**
   * UIAbility 上下文
   */
  private context: common.UIAbilityContext = ContextUtil.getUIAbilityCtx();
  /**
   * 关于页面链接列表
   */
  readonly links: AboutLinkItem[] = [
    {
      title: $r("app.string.main_about_link_doc_title"),
      url: $r("app.string.main_about_link_doc_url")
    },
    {
      title: $r("app.string.main_about_link_github_title"),
      url: $r("app.string.main_about_link_github_url")
    },
    {
      title: $r("app.string.main_about_link_atomgit_title"),
      url: $r("app.string.main_about_link_atomgit_url")
    },
    {
      title: $r("app.string.main_about_link_demo_github_title"),
      url: $r("app.string.main_about_link_demo_github_url")
    },
    {
      title: $r("app.string.main_about_link_demo_gitee_title"),
      url: $r("app.string.main_about_link_demo_gitee_url")
    },
    {
      title: $r("app.string.main_about_link_ui_title"),
      url: $r("app.string.main_about_link_ui_url")
    },
    {
      title: $r("app.string.main_about_link_orm_title"),
      url: $r("app.string.main_about_link_orm_url")
    }
  ];

  /**
   * 打开链接
   * @param {Resource} urlRes - 链接资源
   * @returns {void} 无返回值
   */
  openUrl(urlRes: Resource): void {
    try {
      const url: string = this.context.resourceManager.getStringSync(urlRes.id);
      const want: Want = {
        action: "ohos.want.action.viewData",
        entities: ["entity.system.browsable"],
        uri: url
      };
      this.context.startAbility(want).catch((error: Error) => {
        console.error(`打开链接失败: ${JSON.stringify(error)}`);
      });
    } catch (error) {
      console.error(`打开链接失败: ${JSON.stringify(error)}`);
    }
  }
}
