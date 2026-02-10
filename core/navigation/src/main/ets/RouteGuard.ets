/**
 * @file 路由守卫接口
 * @description 定义路由守卫的接口和上下文
 * @author JunBin.Yang
 */

import { Unknown } from "@core/common";

/**
 * 路由上下文
 * 包含导航相关的信息
 */
export interface RouteContext {
  /**
   * 目标路由名称
   */
  targetRoute: string;

  /**
   * 导航参数
   */
  params?: Unknown;

  /**
   * 来源路由名称
   */
  fromRoute?: string;

  /**
   * 额外数据（可用于守卫间传递信息）
   */
  extra?: Record<string, Unknown>;
}

/**
 * 守卫执行结果
 */
export interface GuardResult {
  /**
   * 是否允许导航
   */
  canActivate: boolean;

  /**
   * 重定向路由（可选）
   */
  redirectTo?: string;

  /**
   * 重定向参数（可选）
   */
  redirectParams?: Unknown;

  /**
   * 拒绝原因（可选）
   */
  reason?: string;
}

/**
 * 路由守卫接口
 * 用于在导航前进行拦截和校验
 */
export interface RouteGuard {
  /**
   * 守卫名称（用于调试）
   */
  name?: string;

  /**
   * 守卫优先级，数字越小越先执行
   * 默认为 100
   */
  priority?: number;

  /**
   * 判断是否允许导航
   * @param context 路由上下文
   * @returns 是否允许导航，或 GuardResult 对象
   */
  canActivate(context: RouteContext): Promise<boolean | GuardResult> | boolean | GuardResult;

  /**
   * 导航被拒绝时的回调（可选）
   * @param context 路由上下文
   * @param result 守卫结果
   */
  onReject?(context: RouteContext, result: GuardResult): void;
}

/**
 * 简化的守卫配置
 * 用于快速创建守卫
 */
export interface GuardConfig {
  /**
   * 守卫名称
   */
  name?: string;

  /**
   * 守卫优先级
   */
  priority?: number;

  /**
   * 需要拦截的路由列表
   */
  routes?: string[];

  /**
   * 校验函数
   */
  check: () => boolean | Promise<boolean>;

  /**
   * 校验失败时的重定向路由
   */
  redirectTo?: string;

  /**
   * 校验失败时的回调
   */
  onFail?: (context: RouteContext) => void;
}
