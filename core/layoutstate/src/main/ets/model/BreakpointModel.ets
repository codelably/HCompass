/**
 * @file 断点模型定义
 * @author Joker.X
 */

/**
 * 断点类型
 */
export enum BreakpointType {
  /**
   * 超小断点
   */
  XS = "xs",
  /**
   * 小断点
   */
  SM = "sm",
  /**
   * 中断点
   */
  MD = "md",
  /**
   * 大断点
   */
  LG = "lg"
}

/**
 * 断点规则
 */
export interface BreakpointRule {
  /**
   * 断点类型
   */
  name: BreakpointType;

  /**
   * 最大宽度
   */
  maxWidthVp: number;
}

/**
 * 断点值配置
 */
export interface BreakpointValueOptions<T> {
  /**
   * 超小断点
   */
  xs?: T;

  /**
   * 小断点
   */
  sm?: T;

  /**
   * 中断点
   */
  md?: T;

  /**
   * 大断点
   */
  lg?: T;
}
