import { BaseViewModel } from "@core/base";
import { getContainer, CoreServiceKeys } from "@core/di";
import { DEMO_NAV_SVC_KEY, IDemoNavSvc } from "@shared/contracts";
import { NavigationService } from "@core/navigation";
import { ExpandCardItem } from "../models/ExpandCardItem";

/**
 * @file 扩展页面 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class ExpandViewModel extends BaseViewModel {
  /**
   * 扩展模块卡片数据
   */
  @Trace
  readonly cards: ExpandCardItem[] = [
    {
      title: $r("app.string.main_expand_safe_area_title"),
      description: $r("app.string.main_expand_safe_area_desc"),
      onClick: () => {
        const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
        DemoNavigator?.toSafeAreaDemo()
      }
    },
    {
      title: $r("app.string.main_expand_screen_adapt_title"),
      description: $r("app.string.main_expand_screen_adapt_desc"),
      onClick: () => {
        const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
        DemoNavigator?.toScreenAdaptDemo()
      }
    },
    {
      title: $r("app.string.main_expand_immersive_light_title"),
      description: $r("app.string.main_expand_immersive_light_desc"),
      onClick: () => {
        getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService)
          ?.navigateTo('ImmersiveLightView');
      }
    },
    {
      title: $r("app.string.main_expand_adaptive_tab_title"),
      description: $r("app.string.main_expand_adaptive_tab_desc"),
      onClick: () => {
        getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService)
          ?.navigateTo('AdaptiveTabView');
      }
    }
  ];
}
