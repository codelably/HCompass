/**
 * @file 商品搜索分页请求模型
 * @author Joker.X
 */
export class GoodsSearchRequest {
  /**
   * 页码
   */
  page: number = 1;
  /**
   * 每页大小
   */
  size: number = 20;

  /**
   * @param {Partial<GoodsSearchRequest>} init - 初始化数据
   */
  constructor(init?: Partial<GoodsSearchRequest>) {
    if (!init) {
      return;
    }
    this.page = init.page ?? this.page;
    this.size = init.size ?? this.size;
  }
}
