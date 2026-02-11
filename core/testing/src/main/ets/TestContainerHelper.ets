/**
 * @file 测试容器辅助类
 * @description 基于 DI 子容器机制，提供测试环境下的服务 Mock 注入与隔离能力
 * @author JunBin.Yang
 */

import { getContainer, Container, setContainer, ServiceKey } from "@core/di";

/**
 * 测试容器辅助类
 * 通过创建子容器实现测试隔离，子容器中注册的 Mock 服务优先于父容器的真实服务
 * @example
 * const helper = new TestContainerHelper();
 * helper.setup();
 * helper.registerMock<IAuthRepository>(AUTH_REPOSITORY_KEY, mockAuthRepo);
 * // ... 执行测试 ...
 * helper.teardown();
 */
export class TestContainerHelper {
  private originalContainer: Container | undefined;
  private testContainer: Container | undefined;
  private isSetup: boolean = false;

  /**
   * 初始化测试环境
   * 保存当前全局容器引用，创建子容器并替换全局容器
   * @throws 重复调用 setup() 而未 teardown() 时抛出异常
   */
  setup(): void {
    if (this.isSetup) {
      throw new Error("[TestContainerHelper] 请先调用 teardown() 再重新 setup()");
    }
    this.originalContainer = getContainer();
    this.testContainer = this.originalContainer.createChild();
    setContainer(this.testContainer);
    this.isSetup = true;
  }

  /**
   * 注册 Mock 服务到测试子容器
   * @template T 服务类型
   * @param key 服务标识符
   * @param mock Mock 服务实例
   * @throws 未调用 setup() 时抛出异常
   */
  registerMock<T>(key: ServiceKey, mock: T): void {
    if (!this.isSetup || !this.testContainer) {
      throw new Error("[TestContainerHelper] 请先调用 setup() 再注册 Mock 服务");
    }
    this.testContainer.register<T>(key, () => mock);
  }

  /**
   * 清理测试环境，恢复原始全局容器
   */
  teardown(): void {
    if (this.originalContainer) {
      setContainer(this.originalContainer);
    }
    this.originalContainer = undefined;
    this.testContainer = undefined;
    this.isSetup = false;
  }
}