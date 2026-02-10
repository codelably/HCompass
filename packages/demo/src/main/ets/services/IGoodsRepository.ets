/**
 * @file 商品相关仓库类，封装商品模块请求
 * @description 如果需要与其他模块共享，请移到 shared/contracts 共享契约层
 * @author JunBin.Yang
 */

import { NetworkPageData, NetworkResult } from "@core/network";
import { Goods } from "@shared/types";
import { GoodsSearchRequest } from "../models/GoodsSearchRequest";

/**
 * 定义跨功能包共享的 DI 服务键
 * @description 不跨包共享时不需要 Key
 */
export const GOODS_REPOSITORY_KEY: string = "goodsRepository";

export interface IGoodsRepository {
  /**
   * 分页查询商品
   * @param params 商品搜索请求参数
   * @returns 商品分页数据
   */
  getGoodsPage(params: GoodsSearchRequest): Promise<NetworkResult<NetworkPageData<Goods>>>;

  /**
   * 获取商品信息
   * @param id 商品ID
   * @returns 商品详情
   */
  getGoodsInfo(id: string): Promise<NetworkResult<Goods>>;
}