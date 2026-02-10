/**
 * @file 认证模块
 * @description 实现 FeatureModule 接口，提供模块自动注册
 * @author JunBin.Yang
 */

import { Container, CoreServiceKeys, getContainer } from '@core/di';
import { FeatureModule, RouteRegistry, ModuleContext } from '@core/module';
import { NavigationService, RouteGuard, RouteContext, GuardResult } from '@core/navigation';
import { AuthRoutes, AUTH_NAV_SVC_KEY, AUTH_REPOSITORY_KEY, IAuthNavSvc, UserRoutes } from '@shared/contracts';
import { IAuthRepository } from '@shared/contracts';
import { AuthRepositoryImpl } from './services/AuthRepositoryImpl';
import { loginNavBuilderWrapper } from './navigation/LoginNav';
import { AuthNavSvcImpl } from './services/AuthNavSvcImpl';
import { getUserState } from '@shared/state';

/**
 * 认证模块
 * 实现 FeatureModule 接口，支持自动注册
 */
export class AuthModule implements FeatureModule {
  /**
   * 模块唯一标识
   */
  readonly moduleId: string = 'auth';

  /**
   * 模块名称
   */
  readonly moduleName: string = '认证模块';

  /**
   * 模块版本
   */
  readonly version: string = '1.0.0';

  /**
   * 模块依赖
   */
  readonly dependencies: string[] = [];

  /**
   * 注册 DI 服务
   * @param container DI 容器
   */
  registerServices(container: Container): void {
    // 注册本模块服务
    container.register<IAuthNavSvc>(AUTH_NAV_SVC_KEY, () => new AuthNavSvcImpl());
    container.register<IAuthRepository>(AUTH_REPOSITORY_KEY, () => new AuthRepositoryImpl());
  }

  /**
   * 注册路由
   * @param registry 路由注册器
   */
  registerRoutes(registry: RouteRegistry): void {
    // 注册登录页路由
    registry.register(AuthRoutes.Login, loginNavBuilderWrapper);
  }

  /**
   * 注册路由守卫
   * @param navigationService 导航服务
   */
  registerGuards(navigationService: NavigationService): void {
    // 注册认证守卫（保护需要登录的页面）
    navigationService.registerGuard(new AuthGuard());
  }

  /**
   * 模块初始化
   * @param context 模块上下文
   */
  async onInit(context: ModuleContext): Promise<void> {
    console.info(`[AuthModule] 模块初始化完成: ${this.moduleName} v${this.version}`);
  }

  /**
   * 模块销毁
   */
  onDestroy(): void {
    console.info(`[AuthModule] 模块已销毁: ${this.moduleName}`);
  }
}

/**
 * 认证路由守卫
 * 保护需要登录才能访问的页面
 */
class AuthGuard implements RouteGuard {
  /**
   * 守卫名称
   */
  readonly name: string = 'AuthGuard';

  /**
   * 守卫优先级（数字越大优先级越高）
   */
  readonly priority: number = 100;

  /**
   * 需要认证的路由
   */
  private readonly protectedRoutes: string[] = [
    UserRoutes.Profile
  ];

  /**
   * 判断路由是否需要登录
   * @param {string} routeName - 路由名称
   * @returns {boolean} true表示需要登录
   */
  private requiresLogin(routeName: string): boolean {
    return this.protectedRoutes.includes(routeName);
  }

  /**
   * 检查是否可以激活路由
   * @param context 路由上下文
   * @returns 是否允许导航
   */
  canActivate(context: RouteContext): boolean | Promise<boolean> {
    const targetRoute = context.targetRoute;

    // 检查是否是受保护的路由
    const isProtected = this.requiresLogin(targetRoute);

    if (!isProtected) {
      return true;
    }

    // 检查是否已登录
    const userState = getUserState();
    if (userState.isLoggedIn()) {
      return true;
    }

    return false;
  }

  /**
   * 守卫拒绝时的回调
   * @param context 路由上下文
   * @param result 守卫结果
   */
  onReject(context: RouteContext, result: GuardResult): void {
    // 跳转到登录页
    const navigation = getContainer().tryResolve<NavigationService>(CoreServiceKeys.NavigationService);
    navigation?.navigateTo(AuthRoutes.Login, context.params);
  }
}

/**
 * 创建认证模块实例
 */
export function createAuthModule(): AuthModule {
  return new AuthModule();
}
