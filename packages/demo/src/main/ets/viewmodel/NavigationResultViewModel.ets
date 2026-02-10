import { BaseViewModel } from "@core/base";
import { CoreServiceKeys, getContainer } from "@core/di";
import { NavigationService } from "@core/navigation";
import { DemoNavResult } from "@shared/types";

/**
 * @file 结果回传示例页 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class NavigationResultViewModel extends BaseViewModel {
  /**
   * 标题输入值
   */
  @Trace
  titleInput: string = "";
  /**
   * 说明输入值
   */
  @Trace
  descInput: string = "";

  /**
   * 更新标题输入
   * @param {string} value - 标题输入内容
   * @returns {void} 无返回值
   */
  updateTitleInput(value: string): void {
    this.titleInput = value;
  }

  /**
   * 更新说明输入
   * @param {string} value - 说明输入内容
   * @returns {void} 无返回值
   */
  updateDescInput(value: string): void {
    this.descInput = value;
  }

  /**
   * 组装结果并返回上一页
   * @returns {void} 无返回值
   */
  submitResult(): void {
    const result: DemoNavResult = {
      title: this.titleInput.trim(),
      description: this.descInput.trim()
    };
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateBackWithResult(result);
  }
}
