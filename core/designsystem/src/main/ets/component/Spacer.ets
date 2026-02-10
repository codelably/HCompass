/**
 * @file 通用间距组件
 * @author Joker.X
 */

/**
 * 创建一个超大垂直间距（32vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceVerticalXXLarge(): void {
  Blank().height($r("app.float.space_vertical_large_xx"));
}

/**
 * 创建一个特大垂直间距（24vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceVerticalXLarge(): void {
  Blank().height($r("app.float.space_vertical_large_x"));
}

/**
 * 创建一个大垂直间距（16vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceVerticalLarge(): void {
  Blank().height($r("app.float.space_vertical_large"));
}

/**
 * 创建一个中等垂直间距（12vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceVerticalMedium(): void {
  Blank().height($r("app.float.space_vertical_medium"));
}

/**
 * 创建一个小垂直间距（8vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceVerticalSmall(): void {
  Blank().height($r("app.float.space_vertical_small"));
}

/**
 * 创建一个超小垂直间距（4vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceVerticalXSmall(): void {
  Blank().height($r("app.float.space_vertical_small_x"));
}

/**
 * 创建一个超大水平间距（32vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceHorizontalXXLarge(): void {
  Blank().width($r("app.float.space_horizontal_large_xx"));
}

/**
 * 创建一个特大水平间距（24vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceHorizontalXLarge(): void {
  Blank().width($r("app.float.space_horizontal_large_x"));
}

/**
 * 创建一个大水平间距（16vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceHorizontalLarge(): void {
  Blank().width($r("app.float.space_horizontal_large"));
}

/**
 * 创建一个中等水平间距（12vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceHorizontalMedium(): void {
  Blank().width($r("app.float.space_horizontal_medium"));
}

/**
 * 创建一个小水平间距（8vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceHorizontalSmall(): void {
  Blank().width($r("app.float.space_horizontal_small"));
}

/**
 * 创建一个超小水平间距（4vp）
 * @returns {void} 无返回值
 */
@Builder
export function SpaceHorizontalXSmall(): void {
  Blank().width($r("app.float.space_horizontal_small_x"));
}
