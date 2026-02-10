import { BaseNetWorkViewModel } from "@core/base";
import { Goods } from "@shared/types";
import { NetworkResult } from "@core/network";
import { IGoodsRepository } from "../services/IGoodsRepository";
import { GoodsRepositoryImpl } from "../services/GoodsRepositoryImpl";

/**
 * @file Network Demo 示例页 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class NetworkDemoViewModel extends BaseNetWorkViewModel<Goods> {
  /**
   * 商品仓库
   */
  private repository: IGoodsRepository = new GoodsRepositoryImpl();

  /**
   * 请求商品详情数据
   * @returns {Promise<NetworkResponse<Goods>>} 网络请求 Promise
   */
  protected requestRepository(): Promise<NetworkResult<Goods>> {
    return this.repository.getGoodsInfo("1");
  }
}
