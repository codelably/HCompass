/**
 * @file 分页元数据模型
 * @author Joker.X
 */
export class NetworkPageMeta {
  /**
   * 总条数
   */
  total: number | null;
  /**
   * 每页显示条数
   */
  size: number | null;
  /**
   * 当前页码
   */
  page: number | null;

  /**
   * 构造函数，对接口返回做空值兜底
   * @param {Partial<NetworkPageMeta>} payload - 接口返回的分页数据
   */
  constructor(payload?: Partial<NetworkPageMeta>) {
    this.total = payload?.total ?? null;
    this.size = payload?.size ?? null;
    this.page = payload?.page ?? null;
  }
}
