import { NetworkPageData, NetworkResult } from "@core/network";
import { Goods } from "@shared/types";
import { GoodsSearchRequest } from "../models/GoodsSearchRequest";
import { GoodsNetworkDataSource } from "./datasource/GoodsNetworkDataSource";
import { GoodsNetworkDataSourceImpl } from "./datasource/GoodsNetworkDataSourceImpl";
import { IGoodsRepository } from "./IGoodsRepository";

/**
 * @file 商品相关仓库类，封装商品模块请求
 * @author Joker.X
 */
export class GoodsRepositoryImpl implements IGoodsRepository {
  /**
   * 商品网络数据源
   */
  private networkDataSource: GoodsNetworkDataSource;

  /**
   * 构造函数
   * @param networkDataSource 可选的商品网络数据源实例
   */
  constructor(networkDataSource?: GoodsNetworkDataSource) {
    this.networkDataSource = networkDataSource ?? new GoodsNetworkDataSourceImpl();
  }

  /**
   * 分页查询商品
   * @param params 商品搜索请求参数
   * @returns 商品分页数据
   */
  async getGoodsPage(params: GoodsSearchRequest): Promise<NetworkResult<NetworkPageData<Goods>>> {
    return this.networkDataSource.getGoodsPage(params);
  }

  /**
   * 获取商品信息
   * @param id 商品ID
   * @returns 商品详情
   */
  async getGoodsInfo(id: string): Promise<NetworkResult<Goods>> {
    return this.networkDataSource.getGoodsInfo(id);
  }
}
