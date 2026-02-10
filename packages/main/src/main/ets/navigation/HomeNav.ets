/**
 * @file 首页导航构建器
 * @description 首页路由注册
 * @author JunBin.Yang
 */

import { MainPage } from '../view/MainPage';

/**
 * @file 主页面导航入口
 * @returns {void} 无返回值
 * @author Joker.X
 */
@Builder
export function MainNav(): void {
  MainPage();
}

/**
 * 导出包装后的构建器
 */
export const MainNavWrapper: WrappedBuilder<[]> = wrapBuilder(MainNav);
