/**
 * @file 沉浸光感模块常量定义
 * @author JunBin.Yang
 */

export enum StorageKey {
  UI_CONTEXT = 'hcompass_spatialization_UIContext',
  GLOBAL_INFO = 'hcompass_spatialization_GlobalInfoModel',
  MATERIAL_LEVEL = 'hcompass_spatialization_MaterialLevel',
}

export class SpatializationConstants {
  /** 中屏横屏宽高比阈值 */
  static readonly ASPECT_LANDSCAPE_SQUARE: number = 9 / 7.2;
  /** 小屏竖屏宽高比阈值 */
  static readonly ASPECT_SQUARE_PORTRAIT: number = 9 / 10.8;
}
