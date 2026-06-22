/**
 * @file 模块基类
 * @description 提供功能模块的基类实现
 * @author JunBin.Yang
 */

import { Container } from '@core/di';
import { NavigationService } from '@core/navigation';
import { FeatureModule, ModuleContext, RouteRegistry } from './FeatureModule';

/**
 * 模块基类
 * 提供功能模块的默认实现
 */
export abstract class BaseModule implements FeatureModule {
  /**
   * 模块唯一标识（子类必须实现）
   */
  abstract readonly moduleId: string;

  /**
   * 模块名称
   */
  readonly moduleName?: string;

  /**
   * 模块版本
   */
  readonly version?: string;

  /**
   * 模块依赖
   */
  readonly dependencies?: string[];

  /**
   * 注册服务（子类可选实现）
   * @param container DI 容器
   */
  registerServices?(container: Container): void;

  /**
   * 注册路由（子类可选实现）
   * @param registry 路由注册器
   */
  registerRoutes?(registry: RouteRegistry): void;

  /**
   * 注册守卫（子类可选实现）
   * @param navigationService 导航服务
   */
  registerGuards?(navigationService: NavigationService): void;

  /**
   * 模块初始化（子类可选实现）
   * @param context 模块上下文
   */
  onInit?(context: ModuleContext): Promise<void> | void;

  /**
   * 模块销毁（子类可选实现）
   */
  onDestroy?(): void;
}
