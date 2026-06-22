/**
 * @file HDS 页面容器组件，封装 HdsNavDestination 并绑定 ViewModel 生命周期
 * @author JunBin.Yang
 */

import { BaseViewModel } from "@core/base";
import { HdsNavDestination } from "@kit.UIDesignKit";

@ComponentV2
export struct AppHdsNavDestination {
  @Param @Require viewModel: BaseViewModel;
  @BuilderParam content: CustomBuilder;
  @Param hideTitleBar: boolean = false;

  aboutToAppear(): void { this.viewModel.aboutToAppear(); }
  aboutToDisappear(): void { this.viewModel.aboutToDisappear(); }
  aboutToBeDeleted(): void { this.viewModel.aboutToBeDeleted(); }
  onDidBuild(): void { this.viewModel.onDidBuild(); }
  aboutToRecycle(): void { this.viewModel.aboutToRecycle(); }
  onWillApplyTheme(theme: Theme): void { this.viewModel.onWillApplyTheme(theme); }

  build() {
    HdsNavDestination() {
      if (this.content) {
        this.content();
      }
    }
    .hideTitleBar(this.hideTitleBar)
    .onShown((reason: VisibilityChangeReason) => { this.viewModel.onShown(reason); })
    .onHidden((reason: VisibilityChangeReason) => { this.viewModel.onHidden(reason); })
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
  }
}
