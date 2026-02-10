/**
 * @file Demo 模块导航参数定义
 * @description 如果需要与其他模块共享，请移到 shared/types 共享契约层
 * @author Joker.X
 */

/**
 * 商品 ID 参数
 */
export interface DemoGoodsParam {
  /**
   * 商品 ID
   */
  goodsId: number;
  /**
   * 商品名称
   */
  goodsName: Resource;
}
