/**
 * @file 沉浸光感材质工具类
 * @author JunBin.Yang
 *
 * API 23 降级方案：HdsNavigation/HdsTabs 的 systemMaterialEffect 已原生支持沉浸效果，
 * 通用组件使用 backgroundBlurStyle 降级替代，升级至 API 26+ 后可启用 ImmersiveMaterial。
 */

export interface MaterialModifierOptions {
  modifier: CommonModifier;
  /** 降级时的背景色 */
  backgroundColor?: ResourceColor;
  /** 降级时的背景模糊样式 */
  backgroundBlurStyle?: BlurStyle;
  materialColor?: ResourceColor;
}

export class MaterialUtil {
  /**
   * 为通用组件 Modifier 应用材质效果
   * @param options 修饰器配置
   * @returns 已应用样式的 CommonModifier
   */
  public static getMaterialModifier(options: MaterialModifierOptions): CommonModifier {
    if (options.backgroundColor) {
      options.modifier.backgroundColor(options.backgroundColor);
    }
    if (options.backgroundBlurStyle) {
      options.modifier.backgroundBlurStyle(options.backgroundBlurStyle);
    }
    return options.modifier;
  }

  /**
   * 为 Menu/Dialog 选项注入材质效果（API 23 原样返回，API 26+ 可注入 systemMaterial）
   * @param option 原始选项对象
   * @returns 选项对象
   */
  public static getMaterialOptions<T>(option: T): T {
    return option;
  }
}
