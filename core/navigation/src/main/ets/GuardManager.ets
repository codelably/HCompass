/**
 * @file 路由守卫管理器
 * @description 管理路由守卫的注册、执行和生命周期
 * @author JunBin.Yang
 */

import { RouteGuard, RouteContext, GuardResult, GuardConfig } from './RouteGuard';
import { Logger } from '@core/util';

const TAG: string = 'GuardManager';

/**
 * 路由守卫管理器
 * 负责管理所有路由守卫的注册和执行
 */
export class GuardManager {
  /**
   * 已注册的守卫列表
   */
  private guards: RouteGuard[] = [];

  /**
   * 是否启用日志
   */
  private enableLog: boolean = true;

  /**
   * 构造函数
   * @param enableLog 是否启用日志
   */
  constructor(enableLog: boolean = true) {
    this.enableLog = enableLog;
  }

  /**
   * 注册路由守卫
   * @param guard 守卫实例
   */
  register(guard: RouteGuard): void {
    // 按优先级排序插入
    const priority = guard.priority ?? 100;
    let insertIndex = this.guards.findIndex(g => (g.priority ?? 100) > priority);
    if (insertIndex === -1) {
      insertIndex = this.guards.length;
    }
    this.guards.splice(insertIndex, 0, guard);

    this.log(`Guard registered: ${guard.name ?? 'unnamed'}, priority: ${priority}`);
  }

  /**
   * 注销路由守卫
   * @param guard 守卫实例
   * @returns 是否注销成功
   */
  unregister(guard: RouteGuard): boolean {
    const index = this.guards.indexOf(guard);
    if (index !== -1) {
      this.guards.splice(index, 1);
      this.log(`Guard unregistered: ${guard.name ?? 'unnamed'}`);
      return true;
    }
    return false;
  }

  /**
   * 通过名称注销守卫
   * @param name 守卫名称
   * @returns 是否注销成功
   */
  unregisterByName(name: string): boolean {
    const index = this.guards.findIndex(g => g.name === name);
    if (index !== -1) {
      this.guards.splice(index, 1);
      this.log(`Guard unregistered by name: ${name}`);
      return true;
    }
    return false;
  }

  /**
   * 执行所有守卫
   * @param context 路由上下文
   * @returns 守卫执行结果
   */
  async runGuards(context: RouteContext): Promise<GuardResult> {
    this.log(`Running guards for route: ${context.targetRoute}`);

    for (const guard of this.guards) {
      try {
        const result = await this.executeGuard(guard, context);

        if (!result.canActivate) {
          this.log(`Guard "${guard.name ?? 'unnamed'}" rejected navigation to ${context.targetRoute}`);

          // 调用拒绝回调
          if (guard.onReject) {
            guard.onReject(context, result);
          }

          return result;
        }
      } catch (error) {
        this.logError(`Guard "${guard.name ?? 'unnamed'}" threw error: ${error}`);
        return {
          canActivate: false,
          reason: `Guard error: ${error}`
        };
      }
    }

    this.log(`All guards passed for route: ${context.targetRoute}`);
    return { canActivate: true };
  }

  /**
   * 执行单个守卫
   * @param guard 守卫实例
   * @param context 路由上下文
   * @returns 守卫结果
   */
  private async executeGuard(guard: RouteGuard, context: RouteContext): Promise<GuardResult> {
    const result = await guard.canActivate(context);

    if (typeof result === 'boolean') {
      return { canActivate: result };
    }

    return result;
  }

  /**
   * 清空所有守卫
   */
  clear(): void {
    this.guards = [];
    this.log('All guards cleared');
  }

  /**
   * 获取已注册的守卫数量
   * @returns 守卫数量
   */
  get size(): number {
    return this.guards.length;
  }

  /**
   * 获取所有守卫名称
   * @returns 守卫名称列表
   */
  getGuardNames(): string[] {
    return this.guards.map(g => g.name ?? 'unnamed');
  }

  /**
   * 设置是否启用日志
   * @param enable 是否启用
   */
  setLogEnabled(enable: boolean): void {
    this.enableLog = enable;
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

/**
 * 通用守卫类
 */
class GenericGuard implements RouteGuard {
  name?: string;
  priority: number;
  private config: GuardConfig;

  constructor(config: GuardConfig) {
    this.config = config;
    this.name = config.name;
    this.priority = config.priority ?? 100; // 默认优先级与接口一致
  }

  async canActivate(context: RouteContext): Promise<GuardResult> {
    // 如果指定了路由列表，且当前路由不在其中，则跳过校验（放行）
    if (this.config.routes && this.config.routes.length > 0) {
      if (!this.config.routes.includes(context.targetRoute)) {
        return { canActivate: true };
      }
    }

    // 执行自定义校验逻辑
    const passed = await this.config.check();

    if (passed) {
      return { canActivate: true };
    }

    return {
      canActivate: false,
      redirectTo: this.config.redirectTo
    };
  }

  onReject(context: RouteContext, _result: GuardResult): void {
    if (this.config.onFail) {
      this.config.onFail(context);
    }
  }
}

/**
 * 从配置创建守卫
 * @param config 守卫配置
 * @returns 路由守卫实例
 */
export function createGuard(config: GuardConfig): RouteGuard {
  return new GenericGuard(config);
}
