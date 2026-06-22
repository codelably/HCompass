/**
 * @file 全局模块注册器
 * @description 提供全局单例的模块注册器
 * @author JunBin.Yang
 */

import { Container, getContainer } from '@core/di';
import { NavigationService } from '@core/navigation';
import { FeatureModule, RouteRegistry, DefaultRouteRegistry } from './FeatureModule';
import { ModuleRegistry, ModuleRegistryConfig, ModuleState } from './ModuleRegistry';

/**
 * 全局模块注册器实例
 */
let globalRegistry: ModuleRegistry | undefined;

/**
 * 获取全局模块注册器
 * @returns 模块注册器实例
 */
export function getModuleRegistry(): ModuleRegistry {
  if (!globalRegistry) {
    globalRegistry = new ModuleRegistry();
  }
  return globalRegistry;
}

/**
 * 设置全局模块注册器
 * @param registry 模块注册器实例
 */
export function setModuleRegistry(registry: ModuleRegistry): void {
  globalRegistry = registry;
}

/**
 * 创建模块注册器
 * @param config 配置选项
 * @returns 模块注册器实例
 */
export function createModuleRegistry(config?: ModuleRegistryConfig): ModuleRegistry {
  return new ModuleRegistry(config);
}

/**
 * 注册模块到全局注册器
 * @param module 功能模块
 */
export function registerModule(module: FeatureModule): void {
  getModuleRegistry().register(module);
}

/**
 * 批量注册模块到全局注册器
 * @param modules 功能模块数组
 */
export function registerModules(modules: FeatureModule[]): void {
  getModuleRegistry().registerAll(modules);
}

/**
 * 启动全局模块注册器
 */
export async function bootstrapModules(): Promise<void> {
  await getModuleRegistry().bootstrap();
}

/**
 * 获取模块状态
 * @param moduleId 模块 ID
 * @returns 模块状态
 */
export function getModuleState(moduleId: string): ModuleState | undefined {
  return getModuleRegistry().getModuleState(moduleId);
}

/**
 * 销毁全局模块注册器
 */
export function destroyModules(): void {
  if (globalRegistry) {
    globalRegistry.destroy();
    globalRegistry = undefined;
  }
}

/**
 * 重置全局模块注册器
 */
export function resetModuleRegistry(): void {
  destroyModules();
  globalRegistry = new ModuleRegistry();
}
