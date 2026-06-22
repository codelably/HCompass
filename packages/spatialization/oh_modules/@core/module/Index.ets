/**
 * @file Module 模块导出
 * @description 模块注册系统的统一导出
 * @author JunBin.Yang
 */

// 功能模块接口导出
export type { FeatureModule, ModuleContext, RouteRegistry, ModuleMetadata } from './src/main/ets/FeatureModule';
export { DefaultRouteRegistry } from './src/main/ets/FeatureModule';

// 模块注册器导出
export { ModuleRegistry, ModuleState } from './src/main/ets/ModuleRegistry';
export type { ModuleRegistryConfig } from './src/main/ets/ModuleRegistry';

// 全局模块注册器导出
export {
  getModuleRegistry, setModuleRegistry,
  createModuleRegistry, registerModule,
  registerModules, bootstrapModules,
  getModuleState, destroyModules, resetModuleRegistry
} from './src/main/ets/GlobalModuleRegistry';

// 模块基类导出
export { BaseModule } from './src/main/ets/BaseModule';
