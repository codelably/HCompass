import { BaseViewModel } from "@core/base";
import { getContainer } from "@core/di";
import { DEMO_NAV_SVC_KEY, IDemoNavSvc } from "@shared/contracts";
import { CoreCardItem } from "../models/CoreCardItem";

/**
 * @file 核心页面 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class CoreViewModel extends BaseViewModel {
  /**
   * 核心模块卡片数据
   */
  @Trace
  readonly cards: CoreCardItem[] = [
    {
      title: $r("app.string.main_core_network_demo_title"),
      description: $r("app.string.main_core_network_demo_desc"),
      onClick: () => {
        const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
        DemoNavigator?.toNetworkDemo();
      }
    },
    {
      title: $r("app.string.main_core_network_list_demo_title"),
      description: $r("app.string.main_core_network_list_demo_desc"),
      onClick: () => {
        const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
        DemoNavigator?.toNetworkListDemo();
      }
    },
    {
      title: $r("app.string.main_core_database_title"),
      description: $r("app.string.main_core_database_desc"),
      onClick: () => {
        const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
        DemoNavigator?.toDatabase();
      }
    },
    {
      title: $r("app.string.main_core_local_storage_title"),
      description: $r("app.string.main_core_local_storage_desc"),
      onClick: () => {
        const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
        DemoNavigator?.toLocalStorage();
      }
    },
    {
      title: $r("app.string.main_core_state_management_title"),
      description: $r("app.string.main_core_state_management_desc"),
      onClick: () => {
        const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
        DemoNavigator?.toStateManagement();
      }
    },
    {
      title: $r("app.string.main_core_network_request_title"),
      description: $r("app.string.main_core_network_request_desc"),
      onClick: () => {
        const DemoNavigator = getContainer().tryResolve<IDemoNavSvc>(DEMO_NAV_SVC_KEY);
        DemoNavigator?.toNetworkRequest();
      }
    }
  ];
}
