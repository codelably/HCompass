import { Goods } from "@shared/types";
import { NetworkPageData, NetworkResult } from "@core/network";
import { GoodsSearchRequest } from "../../models/GoodsSearchRequest";

/**
 * @file 商品相关数据源接口
 * 定义商品模块所需的所有网络请求操作
 * @author Joker.X
 */
export interface GoodsNetworkDataSource {
  /**
   * 分页查询商品
   * @param params 商品搜索请求参数
   * @returns 商品分页数据响应
   */
  getGoodsPage(params: GoodsSearchRequest): Promise<NetworkResult<NetworkPageData<Goods>>>;

  /**
   * 获取商品信息
   * @param id 商品ID
   * @returns 商品信息响应
   */
  getGoodsInfo(id: string): Promise<NetworkResult<Goods>>;
}
