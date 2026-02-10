/**
 * @file 导航服务实现
 * @description 本模块的导航服务
 * @author JunBin.Yang
 */

import { IDemoNavSvc, DemoRoutes } from '@shared/contracts';
import { getContainer, CoreServiceKeys } from '@core/di';
import { NavigationService } from '@core/navigation';
import { DemoGoodsParam } from '../models/DemoNavParam';
import { DemoNavResult } from '@shared/types';

export class DemoNavSvcImpl implements IDemoNavSvc {
  /**
   * 跳转到 Network Demo 示例页
   * @returns {void} 无返回值
   */
  toNetworkDemo(): void {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(DemoRoutes.NetworkDemo);
  }

  /**
   * 跳转到 Network List Demo 示例页
   * @returns {void} 无返回值
   */
  toNetworkListDemo(): void {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(DemoRoutes.NetworkListDemo);
  }

  /**
   * 跳转到数据库示例页
   * @returns {void} 无返回值
   */
  toDatabase(): void {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(DemoRoutes.Database);
  }

  /**
   * 跳转到本地存储示例页
   * @returns {void} 无返回值
   */
  toLocalStorage(): void {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(DemoRoutes.LocalStorage);
  }

  /**
   * 跳转到状态管理示例页
   * @returns {void} 无返回值
   */
  toStateManagement(): void {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(DemoRoutes.StateManagement);
  }

  /**
   * 跳转到通用网络请求示例页
   * @returns {void} 无返回值
   */
  toNetworkRequest(): void {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(DemoRoutes.NetworkRequest);
  }

  /**
   * 跳转到带参跳转示例页
   * @param {number} goodsId - 商品 ID
   * @param {Resource} goodsName - 商品名称
   * @returns {void} 无返回值
   */
  toNavigationWithArgs(goodsId: number, goodsName: Resource): void {
    const params: DemoGoodsParam = { goodsId, goodsName };
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(DemoRoutes.NavigationWithArgs, params);
  }

  /**
   * 跳转到结果回传示例页
   * @returns {Promise<DemoResult | undefined>} 返回结果 Promise
   */
  toNavigationResult(): Promise<DemoNavResult | undefined> {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    return navigation!.navigateToForResult<DemoNavResult>(DemoRoutes.NavigationResult);
  }

  /**
   * 跳转到安全区示例页
   * @returns {void} 无返回值
   */
  toSafeAreaDemo(): void {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(DemoRoutes.SafeAreaDemo);
  }

  /**
   * 跳转到屏幕适配示例页
   * @returns {void} 无返回值
   */
  toScreenAdaptDemo(): void {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(DemoRoutes.ScreenAdaptDemo);
  }
}