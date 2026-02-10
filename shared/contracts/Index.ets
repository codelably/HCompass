/**
 * @file Contracts 模块导出
 * @description 共享契约模块的统一导出
 * @author JunBin.Yang
 */

// 路由键导出
export { MainRoutes } from './src/main/ets/IMainNavSvc/MainRoutes';
export { AuthRoutes } from './src/main/ets/IAuthNavSvc/AuthRoutes';
export { UserRoutes } from './src/main/ets/IUserNavSvc/UserRoutes';
export { DemoRoutes } from './src/main/ets/IDemoNavSvc/DemoRoutes';

// 服务契约导出
export { MAIN_NAV_SVC_KEY, IMainNavSvc } from './src/main/ets/IMainNavSvc/IMainNavSvc';
export { AUTH_NAV_SVC_KEY, IAuthNavSvc } from './src/main/ets/IAuthNavSvc/IAuthNavSvc';
export { USER_NAV_SVC_KEY, IUserNavSvc } from './src/main/ets/IUserNavSvc/IUserNavSvc';
export { DEMO_NAV_SVC_KEY, IDemoNavSvc } from './src/main/ets/IDemoNavSvc/IDemoNavSvc';

export { DemoGoodsParam } from './src/main/ets/IDemoNavSvc/DemoParam';
export { DemoResult } from './src/main/ets/IDemoNavSvc/DemoResult';

export { AUTH_REPOSITORY_KEY, IAuthRepository } from './src/main/ets/IAuthRepository/IAuthRepository';
export { USER_INFO_REPOSITORY_KEY, IUserInfoRepository } from './src/main/ets/IUserInfoRepository/IUserInfoRepository';
export { ACCOUNT_STORE_REPOSITORY_KEY, IAccountStoreRepository } from './src/main/ets/IAccountStoreRepository/AccountStoreRepository';