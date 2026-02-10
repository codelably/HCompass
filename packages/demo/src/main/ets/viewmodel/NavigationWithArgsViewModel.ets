import { BaseViewModel } from "@core/base";
import { CoreServiceKeys, getContainer } from "@core/di";
import { NavigationService } from "@core/navigation";
import { DemoRoutes } from "@shared/contracts";
import { DemoGoodsParam } from "../models/DemoNavParam";

/**
 * @file 带参跳转示例页 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class NavigationWithArgsViewModel extends BaseViewModel {
  /**
   * 获取路由参数
   */
  routeParams: DemoGoodsParam|undefined = getContainer().resolve<NavigationService>(CoreServiceKeys.NavigationService).getRouteParams<DemoGoodsParam>(DemoRoutes.NavigationWithArgs);
}
