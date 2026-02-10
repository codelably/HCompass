/**
 * @file 登录页导航构建器
 * @description 登录页路由注册
 * @author JunBin.Yang
 */

import { LoginPage } from '../view/LoginPage';

/**
 * 登录页导航构建器
 */
@Builder
export function loginNavBuilder() {
  LoginPage()
}

/**
 * 导出包装后的构建器
 */
export const loginNavBuilderWrapper: WrappedBuilder<[]> = wrapBuilder(loginNavBuilder);
