/**
 * @file 常用路由守卫
 * @description 提供常用的路由守卫实现
 * @author JunBin.Yang
 */

import { RouteGuard, RouteContext, GuardResult } from './RouteGuard';

/**
 * 登录守卫配置
 */
export interface AuthGuardConfig {
  /**
   * 守卫名称
   */
  name?: string;

  /**
   * 需要登录的路由列表
   */
  protectedRoutes: string[];

  /**
   * 登录页路由
   */
  loginRoute: string;

  /**
   * 检查是否已登录的函数
   */
  isAuthenticated: () => boolean | Promise<boolean>;

  /**
   * 登录拦截时的回调
   */
  onAuthRequired?: (context: RouteContext) => void;
}

/**
 * 实现登录守卫
 */
class AuthGuard implements RouteGuard {
  name?: string;
  priority: number = 10;
  private protectedSet: Set<string>;
  private config: AuthGuardConfig;

  constructor(config: AuthGuardConfig) {
    this.config = config;
    this.name = config.name ?? 'AuthGuard';
    this.protectedSet = new Set(config.protectedRoutes);
  }

  async canActivate(context: RouteContext): Promise<GuardResult> {
    if (!this.protectedSet.has(context.targetRoute)) {
      return { canActivate: true };
    }

    const isLoggedIn = await this.config.isAuthenticated();
    if (isLoggedIn) {
      return { canActivate: true };
    }

    return {
      canActivate: false,
      redirectTo: this.config.loginRoute,
      reason: 'Authentication required'
    };
  }

  onReject(context: RouteContext, _result: GuardResult): void {
    this.config.onAuthRequired?.(context);
  }
}

/**
 * 创建登录守卫
 * @param config 守卫配置
 * @returns 路由守卫实例
 */
export function createAuthGuard(config: AuthGuardConfig): RouteGuard {
  return new AuthGuard(config);
}

/**
 * 权限守卫配置
 */
export interface PermissionGuardConfig {
  /**
   * 守卫名称
   */
  name?: string;

  /**
   * 路由权限映射
   */
  routePermissions: Map<string, string[]>;

  /**
   * 获取用户权限的函数
   */
  getUserPermissions: () => string[] | Promise<string[]>;

  /**
   * 无权限时的重定向路由
   */
  forbiddenRoute?: string;

  /**
   * 无权限时的回调
   */
  onForbidden?: (context: RouteContext, requiredPermissions: string[]) => void;
}

/**
 * 实现权限守卫
 */
class PermissionGuard implements RouteGuard {
  name?: string;
  priority: number = 20;
  private config: PermissionGuardConfig;

  constructor(config: PermissionGuardConfig) {
    this.config = config;
    this.name = config.name ?? 'PermissionGuard';
  }

  async canActivate(context: RouteContext): Promise<GuardResult> {
    const requiredPermissions = this.config.routePermissions.get(context.targetRoute);
    if (!requiredPermissions || requiredPermissions.length === 0) {
      return { canActivate: true };
    }

    const userPermissions = await this.config.getUserPermissions();
    const userSet = new Set(userPermissions);
    const hasAll = requiredPermissions.every(p => userSet.has(p));

    if (hasAll) {
      return { canActivate: true };
    }

    return {
      canActivate: false,
      redirectTo: this.config.forbiddenRoute,
      reason: `Missing permissions: ${requiredPermissions.filter(p => !userSet.has(p)).join(', ')}`
    };
  }

  onReject(context: RouteContext, _result: GuardResult): void {
    if (this.config.onForbidden) {
      const perms = this.config.routePermissions.get(context.targetRoute) ?? [];
      this.config.onForbidden(context, perms);
    }
  }
}

/**
 * 创建权限守卫
 * @param config 守卫配置
 * @returns 路由守卫实例
 */
export function createPermissionGuard(config: PermissionGuardConfig): RouteGuard {
  return new PermissionGuard(config);
}

/**
 * 条件守卫配置
 */
export interface ConditionalGuardConfig {
  /**
   * 守卫名称
   */
  name?: string;

  /**
   * 优先级
   */
  priority?: number;

  /**
   * 条件检查函数
   */
  condition: (context: RouteContext) => boolean | Promise<boolean>;

  /**
   * 条件不满足时的重定向路由
   */
  redirectTo?: string;

  /**
   * 条件不满足时的回调
   */
  onConditionFailed?: (context: RouteContext) => void;
}

/**
 * 实现条件守卫
 */
class ConditionalGuard implements RouteGuard {
  name: string;
  priority: number;
  private config: ConditionalGuardConfig;

  constructor(config: ConditionalGuardConfig) {
    this.config = config;
    this.name = config.name ?? 'ConditionalGuard';
    this.priority = config.priority ?? 50;
  }

  async canActivate(context: RouteContext): Promise<GuardResult> {
    const passed = await this.config.condition(context);
    if (passed) {
      return { canActivate: true };
    }
    return {
      canActivate: false,
      redirectTo: this.config.redirectTo
    };
  }

  onReject(context: RouteContext, _result: GuardResult): void {
    this.config.onConditionFailed?.(context);
  }
}

/**
 * 创建条件守卫
 * @param config 守卫配置
 * @returns 路由守卫实例
 */
export function createConditionalGuard(config: ConditionalGuardConfig): RouteGuard {
  return new ConditionalGuard(config);
}

/**
 * 日志守卫（用于调试）
 * 记录所有导航事件
 */
class LogGuard implements RouteGuard {
  name: string;
  priority: number = 1;

  constructor(name: string = 'LogGuard') {
    this.name = name;
  }

  canActivate(context: RouteContext): GuardResult {
    console.log(`[${this.name}] Navigation: ${context.fromRoute ?? 'root'} -> ${context.targetRoute}`);
    if (context.params) {
      console.log(`[${this.name}] Params: ${JSON.stringify(context.params)}`);
    }
    return { canActivate: true };
  }
}
export function createLogGuard(name: string = 'LogGuard'): RouteGuard {
  return new LogGuard(name);
}
