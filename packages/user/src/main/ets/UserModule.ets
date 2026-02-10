/**
 * @file 用户模块
 * @description 实现 FeatureModule 接口，提供模块自动注册
 * @author JunBin.Yang
 */

import { Container } from '@core/di';
import { FeatureModule, RouteRegistry, ModuleContext } from '@core/module';
import { NavigationService } from '@core/navigation';
import { IUserInfoRepository, IUserNavSvc,
  UserRoutes,
  USER_INFO_REPOSITORY_KEY, USER_NAV_SVC_KEY } from '@shared/contracts';
import { UserInfoRepositoryImpl } from './services/UserInfoRepositoryImpl';
import { profileNavBuilderWrapper } from './navigation/ProfileNav';
import { UserNavSvcImpl } from './services/UserNavSvcImpl';

/**
 * 用户模块
 * 实现 FeatureModule 接口，支持自动注册
 */
export class UserModule implements FeatureModule {
  /**
   * 模块唯一标识
   */
  readonly moduleId: string = 'user';

  /**
   * 模块名称
   */
  readonly moduleName: string = '用户模块';

  /**
   * 模块版本
   */
  readonly version: string = '1.0.0';

  /**
   * 模块依赖
   */
  readonly dependencies: string[] = ['auth'];

  /**
   * 注册 DI 服务
   * @param container DI 容器
   */
  registerServices(container: Container): void {
    // 注册本模块服务
    container.register<IUserNavSvc>(USER_NAV_SVC_KEY, () => new UserNavSvcImpl());
    container.register<IUserInfoRepository>(USER_INFO_REPOSITORY_KEY, () => new UserInfoRepositoryImpl());
  }

  /**
   * 注册路由
   * @param registry 路由注册器
   */
  registerRoutes(registry: RouteRegistry): void {
    // 注册用户页路由
    registry.register(UserRoutes.Profile, profileNavBuilderWrapper);
  }

  /**
   * 注册路由守卫
   * @param navigationService 导航服务
   */
  registerGuards(navigationService: NavigationService): void {
    // 用户模块不需要额外的守卫，依赖 auth 模块的认证守卫
  }

  /**
   * 模块初始化
   * @param context 模块上下文
   */
  async onInit(context: ModuleContext): Promise<void> {
    console.info(`[UserModule] 模块初始化完成: ${this.moduleName} v${this.version}`);
  }

  /**
   * 模块销毁
   */
  onDestroy(): void {
    console.info(`[UserModule] 模块已销毁: ${this.moduleName}`);
  }
}

/**
 * 创建用户模块实例
 */
export function createUserModule(): UserModule {
  return new UserModule();
}
