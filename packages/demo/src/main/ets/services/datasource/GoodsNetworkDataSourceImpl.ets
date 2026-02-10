import { Goods } from "@shared/types";
import { AxiosHttpClient, NetworkPageData, NetworkResult } from "@core/network";
import { GoodsNetworkDataSource } from "./GoodsNetworkDataSource";
import { GoodsSearchRequest } from "../../models/GoodsSearchRequest";
import { CoreServiceKeys, getContainer } from "@core/di";
import { Any, Unknown } from "@core/common";

/**
 * @file 商品相关数据源实现类
 * @author Joker.X
 */
export class GoodsNetworkDataSourceImpl implements GoodsNetworkDataSource {
  /**
   * 分页查询商品
   * @param params 商品搜索请求参数
   * @returns 商品分页数据响应
   */
  async getGoodsPage(params: GoodsSearchRequest): Promise<NetworkResult<NetworkPageData<Goods>>> {
    const httpClient = getContainer().resolve<AxiosHttpClient>(CoreServiceKeys.HttpClient);
    const rawResponse: Unknown = await httpClient.post<Unknown>("goods/info/page", params);
    return new NetworkResult<NetworkPageData<Goods>>(rawResponse);
  }

  /**
   * 获取商品信息
   * @param id 商品ID
   * @returns 商品信息响应
   */
  async getGoodsInfo(id: string): Promise<NetworkResult<Goods>> {
    const httpClient = getContainer().resolve<AxiosHttpClient>(CoreServiceKeys.HttpClient);
    const rawResponse: Unknown = await httpClient.get<Unknown>("goods/info/info", { params: { id } as Any });
    return new NetworkResult<Goods>(rawResponse);
  }
}
