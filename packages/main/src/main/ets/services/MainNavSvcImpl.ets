/**
 * @file 导航服务实现
 * @description 本模块的导航服务
 * @author JunBin.Yang
 */

import { IMainNavSvc, MainRoutes } from '@shared/contracts';
import { getContainer, CoreServiceKeys } from '@core/di';
import { NavigationService } from '@core/navigation';

export class MainNavSvcImpl implements IMainNavSvc {
  toMain(): void {
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(MainRoutes.Main);
  }
}