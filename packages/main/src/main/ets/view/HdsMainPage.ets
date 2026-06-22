/**
 * @file HDS 风格主页，使用 HdsTabs 悬浮导航替代标准 Tabs
 * @author JunBin.Yang
 */

import { AppHdsNavDestination } from "@core/components";
import { bp } from "@core/layoutstate";
import { hdsMaterial, HdsTabs } from "@kit.UIDesignKit";
import { getWindowSafeAreaState } from "@core/layoutstate";
import MainViewModel from "../viewmodel/MainViewModel";
import { CorePage } from "./CorePage";
import { NavigationPage } from "./NavigationPage";
import { ExpandPage } from "./ExpandPage";
import { AboutPage } from "./AboutPage";

@ComponentV2
export struct HdsMainPage {
  @Local private vm: MainViewModel = new MainViewModel();

  build() {
    AppHdsNavDestination({
      hideTitleBar: true,
      viewModel: this.vm,
    }) {
      this.MainContent();
    }
  }

  @Builder
  private MainContent() {
    HdsTabs() {
      TabContent() { CorePage(); }.tabBar(new BottomTabBarStyle(this.vm.tabItems[0].icon, this.vm.tabItems[0].title))
      TabContent() { NavigationPage(); }.tabBar(new BottomTabBarStyle(this.vm.tabItems[1].icon, this.vm.tabItems[1].title))
      TabContent() { ExpandPage(); }.tabBar(new BottomTabBarStyle(this.vm.tabItems[2].icon, this.vm.tabItems[2].title))
      TabContent() { AboutPage(); }.tabBar(new BottomTabBarStyle(this.vm.tabItems[3].icon, this.vm.tabItems[3].title))
    }
    .barOverlap(true)
    .vertical(false)
    .barPosition(BarPosition.End)
    .onChange((index: number) => this.vm.handleTabChanged(index))
    .barFloatingStyle({
      barBottomMargin: getWindowSafeAreaState().bottomInset > 0
        ? getWindowSafeAreaState().bottomInset
        : $r('sys.float.padding_level8'),
      adaptToHandedness: true,
      systemMaterialEffect: {
        materialType: hdsMaterial.MaterialType.ADAPTIVE,
        materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
      },
    })
  }
}
