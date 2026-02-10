/**
 * @file DI 模块导出
 * @description 依赖注入容器模块的统一导出
 * @author JunBin.Yang
 */

// 类型导出
export type { ServiceKey, ServiceFactory, ServiceDescriptor, ServiceOptions } from './src/main/ets/ServiceProvider';
export type { Container } from './src/main/ets/Container';

// 实现导出
export { ServiceContainer } from './src/main/ets/ServiceContainer';

// 全局容器导出
export {
  getContainer,
  setContainer,
  resetContainer,
  register,
  resolve,
  tryResolve,
  has
} from './src/main/ets/GlobalContainer';

// 服务键导出
export { CoreServiceKeys } from './src/main/ets/ServiceKeys';
export type { CoreServiceKey } from './src/main/ets/ServiceKeys';
