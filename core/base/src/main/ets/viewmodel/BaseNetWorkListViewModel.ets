import { RequestHelper, NetworkResult, NetworkPageData, NetworkPageMeta } from "@core/network";
import { BaseNetWorkListUiState } from "../state/BaseNetWorkListUiState";
import { BaseViewModel } from "./BaseViewModel";
import { JSON } from "@kit.ArkTS";

/**
 * @file 网络列表请求 ViewModel 基类
 * @description 提供通用的网络列表请求 ViewModel 基类，包含 UI 状态管理和请求执行逻辑。
 * @param T 列表数据项类型
 * @author Joker.X
 */
@ObservedV2
export abstract class BaseNetWorkListViewModel<T> extends BaseViewModel {
  /**
   * 列表页 UI 状态
   */
  @Trace
  uiState: BaseNetWorkListUiState = BaseNetWorkListUiState.LOADING;
  /**
   * 列表数据
   */
  @Trace
  listData: Array<T> = [];
  /**
   * 是否正在加载
   */
  @Trace
  isLoading: boolean = false;
  /**
   * 是否启用上滑加载更多
   */
  @Trace
  isEnableSlideUp: boolean = true;
  /**
   * 当前页码
   */
  protected currentPage: number = 1;
  /**
   * 每页数量
   */
  protected pageSize: number = 10;
  /**
   * 控制请求失败时是否显示 Toast 提示
   */
  protected showErrorToast: boolean = false;

  /**
   * 子类必须实现此方法，返回分页请求 Promise
   * @returns {Promise<NetworkResult<NetworkPageData<T>>>} 网络请求 Promise
   */
  protected abstract requestListData(): Promise<NetworkResult<NetworkPageData<T>>>;

  /**
   * 页面出现时初始化列表数据
   * @returns {void} 无返回值
   */
  aboutToAppear(): void {
    this.initLoad();
  }

  /**
   * 初始化加载（子类可在 aboutToAppear 中调用）
   * @returns {void} 无返回值
   */
  protected initLoad(): void {
    this.loadListData();
  }

  /**
   * 加载列表数据
   * @returns {void} 无返回值
   */
  protected loadListData(): void {
    RequestHelper.from<NetworkPageData<T>>(this.requestListData())
      .toast(this.showErrorToast)
      .execute()
      .then((data: NetworkPageData<T>): void => this.handleSuccess(data))
      .catch((err: Error): void => this.handleError(err))
      .finally((): void => {
        this.isLoading = false;
      });
  }

  /**
   * 处理成功响应
   * @param {NetworkPageData<T>} data - 分页数据
   * @returns {void} 无返回值
   */
  protected handleSuccess(data: NetworkPageData<T> | null): void {
    const pageData: NetworkPageData<T> = new NetworkPageData<T>(data ?? undefined);
    const list: Array<T> = pageData.list ?? [];
    const hasNextPage: boolean = this.calculateHasMore(pageData);

    if (this.currentPage === 1) {
      this.listData = list;
      this.uiState = list.length === 0 ? BaseNetWorkListUiState.EMPTY : BaseNetWorkListUiState.SUCCESS;
      this.isEnableSlideUp = hasNextPage;
      return;
    }

    this.listData = [...this.listData, ...list];
    console.log("数据量:", this.listData.length);
    console.log("本次数据:", JSON.stringify(list));
    console.log("是否还有更多:", hasNextPage);
    this.isEnableSlideUp = hasNextPage;
  }

  /**
   * 处理错误响应
   * @param {Error} err - 错误对象
   * @returns {void} 无返回值
   */
  protected handleError(err: Error): void {
    console.error("[BaseNetWorkListViewModel] error:", err.message);
    if (this.currentPage === 1) {
      if (this.listData.length === 0) {
        this.uiState = BaseNetWorkListUiState.ERROR;
      }
      return;
    }

    this.currentPage -= 1;
  }

  /**
   * 重试请求
   * @returns {void} 无返回值
   */
  retryRequest(): void {
    this.uiState = BaseNetWorkListUiState.LOADING;
    this.currentPage = 1;
    this.loadListData();
  }

  /**
   * 触发下拉刷新
   * @returns {void} 无返回值
   */
  onRefresh(): void {
    if (this.isLoading) {
      return;
    }
    this.isLoading = true;
    this.currentPage = 1;
    this.loadListData();
  }

  /**
   * 触发上滑加载更多
   * @returns {void} 无返回值
   */
  onLoadMore(): void {
    if (this.isLoading || !this.isEnableSlideUp || this.listData.length === 0) {
      return;
    }
    this.isLoading = true;
    this.currentPage += 1;
    this.loadListData();
  }

  /**
   * 处理下拉刷新或上滑加载更多
   * @param {"pull" | "slideUp"} direction - 触发方向
   * @returns {void} 无返回值
   */
  onRefreshDirection(direction: "pull" | "slideUp"): void {
    if (direction === "pull") {
      this.onRefresh();
      return;
    }

    this.onLoadMore();
  }

  /**
   * 计算是否还有更多数据
   * @param {NetworkPageData<T>} pageData - 分页数据
   * @returns {boolean} 是否还有更多
   */
  protected calculateHasMore(pageData: NetworkPageData<T>): boolean {
    const pagination: NetworkPageMeta | null = pageData.pagination;
    return pagination !== null
      && pagination.total !== null
      && pagination.size !== null
      && pagination.page !== null
      && pagination.size * pagination.page < pagination.total;
  }
}
