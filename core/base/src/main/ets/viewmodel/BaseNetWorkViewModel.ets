import { RequestHelper, NetworkResult } from "@core/network";
import { BaseViewModel } from "./BaseViewModel";
import { BaseNetWorkUiState } from "../state/BaseNetWorkUiState";

/**
 * @file 网络请求 ViewModel 基类
 * @description 提供通用的网络请求 ViewModel 基类，包含 UI 状态管理和请求执行逻辑。
 * @param T 网络请求数据项类型
 * @author Joker.X JunBin.Yang
 */
@ObservedV2
export abstract class BaseNetWorkViewModel<T> extends BaseViewModel {
  /**
   * 通用网络请求 UI 状态
   */
  @Trace
  uiState: BaseNetWorkUiState = BaseNetWorkUiState.LOADING;
  /**
   * 请求成功后的数据
   */
  @Trace
  data: T | null = null;
  /**
   * 控制请求失败时是否显示 Toast 提示
   */
  protected showErrorToast: boolean = false;

  /**
   * 子类必须实现此方法，返回网络请求 Promise
   * @returns {Promise<NetworkResult<T>>} 网络请求 Promise
   */
  protected abstract requestRepository(): Promise<NetworkResult<T>>;

  /**
   * 页面出现时的生命周期回调
   * @returns {void} 无返回值
   */
  aboutToAppear(): void {
    this.executeRequest();
  }

  /**
   * 发起请求
   * @returns {void} 无返回值
   */
  executeRequest(): void {
    RequestHelper.fromResult<T>(this.requestRepository())
      .toast(this.showErrorToast)
      .start(() => this.onRequestStart())
      .execute()
      .then((data: T) => this.onRequestSuccess(data))
      .catch(() => this.onRequestError());
  }

  /**
   * 请求开始前回调
   * @returns {void} 无返回值
   */
  protected onRequestStart(): void {
    this.setLoadingState();
  }

  /**
   * 请求成功回调
   * @param {T} data - 成功数据
   * @returns {void} 无返回值
   */
  protected onRequestSuccess(data: T): void {
    this.data = data;
    this.setSuccessState();
  }

  /**
   * 请求失败回调
   * @returns {void} 无返回值
   */
  protected onRequestError(): void {
    this.setErrorState();
  }

  /**
   * 重试请求
   * @returns {void} 无返回值
   */
  retryRequest(): void {
    this.setLoadingState();
    this.executeRequest();
  }

  /**
   * 设置加载中状态
   * @returns {void} 无返回值
   */
  protected setLoadingState(): void {
    this.uiState = BaseNetWorkUiState.LOADING;
  }

  /**
   * 设置成功状态
   * @returns {void} 无返回值
   */
  protected setSuccessState(): void {
    this.uiState = BaseNetWorkUiState.SUCCESS;
  }

  /**
   * 设置错误状态
   * @returns {void} 无返回值
   */
  protected setErrorState(): void {
    this.uiState = BaseNetWorkUiState.ERROR;
  }
}
