/**
 * @file 导航服务
 * @description 支持路由守卫的导航服务
 * @author JunBin.Yang
 */

import { Logger } from '@core/util';
import { Unknown } from "@core/common";
import { RouteGuard, RouteContext, GuardResult } from './RouteGuard';
import { GuardManager } from './GuardManager';

const TAG: string = 'NavigationService';

/**
 * Provider / Consumer 共享的键名
 */
export const NAV_PATH_STACK_KEY: string = "navStack";

/**
 * 导航选项
 */
export interface NavigateOptions {
  /**
   * 是否跳过守卫检查
   */
  skipGuards?: boolean;

  /**
   * 是否需要动画
   */
  animated?: boolean;
}

/**
 * 导航服务
 * 在原 NavigationService 基础上增加路由守卫支持
 */
export class NavigationService {
  /**
   * 导航栈
   */
  private stack: NavPathStack = new NavPathStack();

  /**
   * 守卫管理器
   */
  private guardManager: GuardManager;

  /**
   * 当前路由名称
   */
  private currentRoute: string = '';

  /**
   * 是否启用日志
   */
  private enableLog: boolean = true;

  /**
   * 构造函数
   * @param navStack 导航栈实例
   * @param enableLog 是否启用日志
   */
  constructor(navStack: NavPathStack, enableLog: boolean = true) {
    this.stack = navStack;
    this.enableLog = enableLog;
    this.guardManager = new GuardManager(enableLog);
  }

  /**
   * 获取导航栈
   * @returns 导航栈实例
   */
  getPathStack(): NavPathStack | null {
    return this.stack;
  }

  /**
   * 注册路由守卫
   * @param guard 守卫实例
   */
  registerGuard(guard: RouteGuard): void {
    this.guardManager.register(guard);
  }

  /**
   * 注销路由守卫
   * @param guard 守卫实例
   * @returns 是否注销成功
   */
  unregisterGuard(guard: RouteGuard): boolean {
    return this.guardManager.unregister(guard);
  }

  /**
   * 通过名称注销守卫
   * @param name 守卫名称
   * @returns 是否注销成功
   */
  unregisterGuardByName(name: string): boolean {
    return this.guardManager.unregisterByName(name);
  }

  /**
   * 路由跳转（入栈）
   * @param name 路由名称
   * @param params 跳转参数
   * @param options 导航选项
   * @returns 是否导航成功
   */
  async navigateTo(name: string, params?: Unknown, options?: NavigateOptions): Promise<boolean> {
    if (!this.stack) {
      this.logError('Navigation stack is not initialized');
      return false;
    }

    // 构建路由上下文
    const context: RouteContext = {
      targetRoute: name,
      params,
      fromRoute: this.currentRoute
    };

    // 执行守卫检查（除非跳过）
    if (!options?.skipGuards) {
      const guardResult: GuardResult = await this.guardManager.runGuards(context);

      if (!guardResult.canActivate) {
        // 如果有重定向路由，执行重定向
        if (guardResult.redirectTo) {
          this.log(`Redirecting to: ${guardResult.redirectTo}`);
          return this.navigateTo(guardResult.redirectTo, guardResult.redirectParams, { skipGuards: true });
        }
        return false;
      }
    }

    // 执行导航
    try {
      if (params !== undefined) {
        this.stack.pushPath({
          name: name,
          param: params
        });
      } else {
        this.stack.pushPath({
          name: name
        });
      }

      this.currentRoute = name;
      this.log(`Navigated to: ${name}`);
      return true;
    } catch (err) {
      this.logError(`Navigation failed: ${JSON.stringify(err)}`);
      return false;
    }
  }

  /**
   * 返回上一页
   * @param animated 是否需要动画
   */
  navigateBack(animated?: boolean): void {
    if (!this.stack) {
      return;
    }
    try {
      this.stack.pop(undefined, animated);
      this.log('Navigated back');
    } catch (err) {
      this.logError(`Navigate back failed: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 携带结果返回上一页
   * @param result 返回结果
   * @param animated 是否需要动画
   */
  navigateBackWithResult(result: Object, animated?: boolean): void {
    if (!this.stack) {
      return;
    }
    try {
      this.stack.pop(result, animated);
      this.log('Navigated back with result');
    } catch (err) {
      this.logError(`Navigate back with result failed: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 返回到指定路由
   * @param name 目标路由名称
   * @param inclusive 是否移除目标自身
   */
  popTo(name: string, inclusive: boolean = false): void {
    if (!this.stack) {
      return;
    }
    try {
      this.stack.popToName(name, inclusive);
      this.log(`Popped to: ${name}`);
    } catch (err) {
      this.logError(`Pop to failed: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 跳转并监听返回结果
   * @param name 路由名称
   * @param params 跳转参数
   * @param onPop 返回结果回调
   * @param options 导航选项
   * @returns 是否导航成功
   */
  async navigateToWithResult(
    name: string,
    params?: Unknown,
    onPop?: (info: PopInfo) => void,
    options?: NavigateOptions
  ): Promise<boolean> {
    if (!this.stack) {
      return false;
    }

    // 构建路由上下文
    const context: RouteContext = {
      targetRoute: name,
      params,
      fromRoute: this.currentRoute
    };

    // 执行守卫检查
    if (!options?.skipGuards) {
      const guardResult = await this.guardManager.runGuards(context);

      if (!guardResult.canActivate) {
        if (guardResult.redirectTo) {
          return this.navigateToWithResult(guardResult.redirectTo, guardResult.redirectParams, onPop, { skipGuards: true });
        }
        return false;
      }
    }

    try {
      const safeParam: Object | undefined = params as Object | undefined;
      if (onPop) {
        await this.stack.pushDestinationByName(name, safeParam, onPop);
      } else {
        await this.stack.pushDestinationByName(name, safeParam);
      }

      this.currentRoute = name;
      return true;
    } catch (err) {
      this.logError(`Navigate to with result failed: ${JSON.stringify(err)}`);
      return false;
    }
  }

  /**
   * 跳转并以 Promise 形式获取返回结果
   * @param name 路由名称
   * @param params 跳转参数
   * @param options 导航选项
   * @returns 返回结果
   */
  async navigateToForResult<T>(name: string, params?: object, options?: NavigateOptions): Promise<T | undefined> {
    return new Promise<T | undefined>((resolve) => {
      this.navigateToWithResult(name, params, (info: PopInfo) => {
        resolve(info?.result as T);
      }, options);
    });
  }

  /**
   * 获取指定路由的参数
   * @param name 路由名称
   * @returns 参数对象
   */
  getRouteParams<T>(name: string): T | undefined {
    if (!this.stack) {
      return undefined;
    }
    try {
      return this.stack.getParamByName(name)[0] as T;
    } catch (err) {
      this.logError(`Get route params failed: ${JSON.stringify(err)}`);
      return undefined;
    }
  }

  /**
   * 获取导航栈实例
   * @returns 导航栈
   */
  getStack(): NavPathStack {
    return this.stack;
  }

  /**
   * 获取守卫管理器
   * @returns 守卫管理器
   */
  getGuardManager(): GuardManager {
    return this.guardManager;
  }

  /**
   * 获取当前路由
   * @returns 当前路由名称
   */
  getCurrentRoute(): string {
    return this.currentRoute;
  }

  /**
   * 设置是否启用日志
   * @param enable 是否启用
   */
  setLogEnabled(enable: boolean): void {
    this.enableLog = enable;
    this.guardManager.setLogEnabled(enable);
  }

  /**
   * 记录日志
   */
  private log(message: string): void {
    if (this.enableLog) {
      Logger.info(message, TAG);
    }
  }

  /**
   * 记录错误日志
   */
  private logError(message: string): void {
    Logger.error(message, TAG);
  }
}
