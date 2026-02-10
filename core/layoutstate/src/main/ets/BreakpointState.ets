import { AppStorageV2 } from "@kit.ArkUI";
import { BreakpointRule, BreakpointType, BreakpointValueOptions } from "./model/BreakpointModel";

/**
 * @file 全局断点状态，用于窗口尺寸响应式适配
 * @author Joker.X
 */

/**
 * AppStorageV2 键名
 */
export const BREAKPOINT_STATE_KEY: string = "breakpoint_state";

/**
 * 断点规则
 */
const BREAKPOINT_RULES: BreakpointRule[] = [
  /**
   * 超小断点
   */
  { name: BreakpointType.XS, maxWidthVp: 320 },
  /**
   * 小断点
   */
  { name: BreakpointType.SM, maxWidthVp: 600 },
  /**
   * 中断点
   */
  { name: BreakpointType.MD, maxWidthVp: 840 },
  /**
   * 大断点
   */
  { name: BreakpointType.LG, maxWidthVp: Number.POSITIVE_INFINITY }
];

/**
 * 断点顺序
 */
const BREAKPOINT_ORDER: BreakpointType[] = [
  BreakpointType.XS,
  BreakpointType.SM,
  BreakpointType.MD,
  BreakpointType.LG
];

/**
 * 全局断点状态
 */
@ObservedV2
export class BreakpointState {
  @Trace
  current: BreakpointType = BreakpointType.SM;
  @Trace
  windowWidthVp: number = 0;

  /**
   * 更新窗口宽度并计算断点
   * @param {number} windowWidthVp - 窗口宽度（vp）
   * @returns {void} 无返回值
   * @example
  * state.updateByWidth(360);
   */
  updateByWidth(windowWidthVp: number): void {
    this.windowWidthVp = windowWidthVp;
    const next = this.resolveBreakpoint(windowWidthVp);
    if (this.current !== next) {
      this.current = next;
    }
  }

  /**
   * 根据窗口宽度计算断点
   * @param {number} windowWidthVp - 窗口宽度（vp）
   * @returns {BreakpointType} 断点名称
   */
  resolveBreakpoint(windowWidthVp: number): BreakpointType {
    for (const rule of BREAKPOINT_RULES) {
      if (windowWidthVp < rule.maxWidthVp) {
        return rule.name;
      }
    }
    return BreakpointType.LG;
  }

  /**
   * 是否为超小断点
   * @returns {boolean} 是否超小断点
   */
  isXS(): boolean {
    return this.current === BreakpointType.XS;
  }

  /**
   * 是否为小断点
   * @returns {boolean} 是否小断点
   */
  isSM(): boolean {
    return this.current === BreakpointType.SM;
  }

  /**
   * 是否为中断点
   * @returns {boolean} 是否中断点
   */
  isMD(): boolean {
    return this.current === BreakpointType.MD;
  }

  /**
   * 是否为大断点
   * @returns {boolean} 是否大断点
   */
  isLG(): boolean {
    return this.current === BreakpointType.LG;
  }

  /**
   * 根据当前断点返回适配值
   * @param {BreakpointValueOptions<T>} options - 断点值配置
   * @param {T | undefined} defaultValue - 默认值
   * @returns {T} 适配值
   * @example
  * state.getValue({ sm: $r("app.float.small"), md: $r("app.float.medium") });
   */
  getValue<T>(options: BreakpointValueOptions<T>, defaultValue?: T): T {
    const index = BREAKPOINT_ORDER.indexOf(this.current);
    const fallbackValue = this.getFallbackValue(options, defaultValue);
    if (index < 0) {
      return fallbackValue;
    }

    // 优先取当前断点值
    const currentValue = getValueByName(options, BREAKPOINT_ORDER[index]);
    if (currentValue !== undefined) {
      return currentValue;
    }

    for (let i = index - 1; i >= 0; i--) {
      // 向下回退：找更小断点的兜底值
      const value = getValueByName(options, BREAKPOINT_ORDER[i]);
      if (value !== undefined) {
        return value;
      }
    }

    for (let i = index + 1; i < BREAKPOINT_ORDER.length; i++) {
      // 向上补齐：找更大断点的兜底值
      const value = getValueByName(options, BREAKPOINT_ORDER[i]);
      if (value !== undefined) {
        return value;
      }
    }

    return fallbackValue;
  }

  /**
   * 获取兜底值（优先默认值，其次取配置中第一个可用值）
   * @param {BreakpointValueOptions<T>} options - 断点值配置
   * @param {T | undefined} defaultValue - 默认值
   * @returns {T} 兜底值
   */
  private getFallbackValue<T>(options: BreakpointValueOptions<T>, defaultValue?: T): T {
    if (defaultValue !== undefined) {
      return defaultValue;
    }

    const orderedTypes: BreakpointType[] = [
      BreakpointType.XS,
      BreakpointType.SM,
      BreakpointType.MD,
      BreakpointType.LG
    ];

    for (const type of orderedTypes) {
      const value = getValueByName(options, type);
      if (value !== undefined) {
        return value;
      }
    }

    throw new Error("BreakpointValueOptions 不能为空，请至少提供一个断点值。");
  }
}

/**
 * 获取全局断点状态实例；若不存在则创建
 * @returns {BreakpointState} 全局断点状态
 * @example
* const state = getBreakpointState();
 */
export function getBreakpointState(): BreakpointState {
  return AppStorageV2.connect<BreakpointState>(
    BreakpointState,
    BREAKPOINT_STATE_KEY,
    () => new BreakpointState()
  )!;
}

/**
 * 根据全局断点状态返回适配值
 * @param {BreakpointValueOptions<T>} options - 断点值配置
 * @param {T | undefined} defaultValue - 默认值
 * @returns {T} 适配值
 * @example
* bp({ sm: $r("app.float.small"), md: $r("app.float.medium") });
 */
export function bp<T>(options: BreakpointValueOptions<T>, defaultValue?: T): T {
  return getBreakpointState().getValue(options, defaultValue);
}

/**
 * 根据断点名称获取值
 * @param {BreakpointValueOptions<T>} options - 断点值配置
 * @param {BreakpointType} type - 断点类型
 * @returns {T | undefined} 断点值
 */
function getValueByName<T>(options: BreakpointValueOptions<T>, type: BreakpointType): T | undefined {
  if (type === BreakpointType.XS) {
    return options.xs;
  }
  if (type === BreakpointType.SM) {
    return options.sm;
  }
  if (type === BreakpointType.MD) {
    return options.md;
  }
  return options.lg;
}
