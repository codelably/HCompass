/**
 * @file 沉浸光感演示模块注册
 * @author JunBin.Yang
 */

import { Container } from '@core/di';
import { FeatureModule, ModuleContext, RouteRegistry } from '@core/module';
import { NavigationService } from '@core/navigation';
import { Logger } from '@core/util';
import { ImmersiveLightViewBuilder } from './view/ImmersiveLightView';
import { AdaptiveTabViewBuilder } from './view/AdaptiveTabView';

interface SpatializationRouteMap {
  ImmersiveLightView: string;
  AdaptiveTabView: string;
}

export const SPATIALIZATION_ROUTES: SpatializationRouteMap = {
  ImmersiveLightView: 'ImmersiveLightView',
  AdaptiveTabView: 'AdaptiveTabView',
};

export class SpatializationModule implements FeatureModule {
  readonly moduleId: string = 'spatialization';
  readonly moduleName: string = '沉浸光感演示模块';
  readonly version: string = '1.0.0';
  readonly dependencies: string[] = [];

  registerServices(_container: Container): void {}

  registerRoutes(registry: RouteRegistry): void {
    registry.register(SPATIALIZATION_ROUTES.ImmersiveLightView, wrapBuilder(ImmersiveLightViewBuilder));
    registry.register(SPATIALIZATION_ROUTES.AdaptiveTabView, wrapBuilder(AdaptiveTabViewBuilder));
  }

  registerGuards(_navigationService: NavigationService): void {}

  async onInit(_context: ModuleContext): Promise<void> {
    Logger.info(`[SpatializationModule] 模块初始化: ${this.moduleName} v${this.version}`);
  }

  onDestroy(): void {
    Logger.info(`[SpatializationModule] 模块已销毁: ${this.moduleName}`);
  }
}

export function createSpatializationModule(): SpatializationModule {
  return new SpatializationModule();
}
