import { NetworkPageMeta } from './NetworkPageMeta';

/**
 * @file 网络分页数据模型
 * @author Joker.X
 */
export class NetworkPageData<T> {
  /**
   * 数据列表
   */
  list: Array<T> | null;
  /**
   * 分页元数据
   */
  pagination: NetworkPageMeta | null;

  /**
   * 构造函数，对接口返回做空值兜底
   * @param {Partial<NetworkPageData<T>>} payload - 接口返回的分页数据
   */
  constructor(payload?: Partial<NetworkPageData<T>>) {
    this.list = payload?.list ?? null;
    this.pagination = payload?.pagination ? new NetworkPageMeta(payload.pagination) : null;
  }
}
