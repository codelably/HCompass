/**
 * @file 个人中心页导航构建器
 * @description 个人中心页路由注册
 * @author JunBin.Yang
 */

import { ProfilePage } from '../view/ProfilePage';

/**
 * 个人中心页导航构建器
 */
@Builder
export function profileNavBuilder() {
  ProfilePage()
}

/**
 * 导出包装后的构建器
 */
export const profileNavBuilderWrapper: WrappedBuilder<[]> = wrapBuilder(profileNavBuilder);
