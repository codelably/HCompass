import { BaseNetWorkListViewModel } from "@core/base";
import { Goods } from "@shared/types";
import { NetworkPageData, NetworkResult } from "@core/network";
import { GoodsRepositoryImpl } from "../services/GoodsRepositoryImpl";
import { IGoodsRepository } from "../services/IGoodsRepository";
import { GoodsSearchRequest } from "../models/GoodsSearchRequest";

/**
 * @file Network List Demo 示例页 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class NetworkListDemoViewModel extends BaseNetWorkListViewModel<Goods> {
  /**
   * 商品仓库
   */
  private repository: IGoodsRepository = new GoodsRepositoryImpl();

  /**
   * 请求商品分页数据
   * @returns {Promise<NetworkResult<NetworkPageData<Goods>>>} 网络请求 Promise
   */
  protected requestListData(): Promise<NetworkResult<NetworkPageData<Goods>>> {
    const request: GoodsSearchRequest = new GoodsSearchRequest();
    request.page = this.currentPage;
    request.size = this.pageSize;
    return this.repository.getGoodsPage(request);
  }
}
