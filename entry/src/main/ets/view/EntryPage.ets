import { ContextUtil } from "@core/util";
import { NavigationHost } from "../navigation/NavigationHost";
import EntryViewModel from "../viewmodel/EntryViewModel";

/**
 * @file 应用首页，挂载全局 NavigationHost
 * @author Joker.X
 */
@Entry
@ComponentV2
struct EntryPage {
  @Local vm: EntryViewModel = new EntryViewModel();

  /**
   * 初始化入口逻辑
   * @returns {void} 无返回值
   */
  aboutToAppear(): void {
    const hostContext = ContextUtil.getHostCtx();
    if (!hostContext) {
      console.error("[EntryPage] Failed to obtain host context.");
      return;
    }
    this.vm.aboutToAppear(hostContext);
  }

  /**
   * 释放入口资源
   * @returns {void} 无返回值
   */
  aboutToDisappear(): void {
    this.vm.aboutToDisappear();
  }

  /**
   * 渲染根导航容器
   * @returns {void} 无返回值
   */
  build() {
    Column() {
      NavigationHost()
    }
  }
}
