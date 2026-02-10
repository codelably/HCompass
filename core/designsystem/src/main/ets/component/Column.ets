import { P100 } from "../constants/LayoutPercent";

/**
 * @file 通用 Column 布局简化组件
 * @author Joker.X
 */

/**
 * 通用 Column 布局（保留官方 Column 能力）
 */
@ComponentV2
export struct ColumnBase {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 主轴对齐方式
   */
  @Param
  justifyContent: FlexAlign = FlexAlign.Start;
  /**
   * 交叉轴对齐方式
   */
  @Param
  alignItems: HorizontalAlign = HorizontalAlign.Start;
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 构建通用 Column 布局
   * @returns {void} 无返回值
   * @example
  * ColumnBase({ fillMaxSize: true }) { Text("Hi"); }
   */
  build(): void {
    Column(this.options) {
      if (this.content) {
        this.content();
      }
    }
    .justifyContent(this.justifyContent)
    .alignItems(this.alignItems)
    .attributeModifier(this.buildCommonModifier());
  }

  /**
   * 构建通用属性修饰器
   * @returns {AttributeModifier<ColumnAttribute>} Column 属性修饰器
   */
  private buildCommonModifier(): AttributeModifier<ColumnAttribute> {
    const size = this.sizeValue;
    const fillMaxSize = this.fillMaxSize;
    const width = this.widthValue;
    const height = this.heightValue;
    const padding = this.paddingValue;
    const margin = this.marginValue;
    const backgroundColor = this.bgColor;
    const onClick = this.onTap;

    return {
      applyNormalAttribute: (instance: ColumnAttribute): void => {
        if (size) {
          instance.size(size);
        } else if (fillMaxSize) {
          instance.size({ width: P100, height: P100 });
        } else {
          if (width !== undefined) {
            instance.width(width);
          }
          if (height !== undefined) {
            instance.height(height);
          }
        }

        if (padding !== undefined) {
          instance.padding(padding);
        }

        if (margin !== undefined) {
          instance.margin(margin);
        }

        if (backgroundColor !== undefined) {
          instance.backgroundColor(backgroundColor);
        }

        if (onClick) {
          instance.onClick((event: ClickEvent) => {
            onClick(event);
          });
        }
      }
    };
  }
}

/**
 * 纵向居中 + 水平居中
 */
@ComponentV2
export struct ColumnCenter {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnCenter() { Text("Hi"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.Center,
      alignItems: HorizontalAlign.Center,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向起始 + 水平起始
 */
@ComponentV2
export struct ColumnStart {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnStart() { Text("Hi"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.Start,
      alignItems: HorizontalAlign.Start,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向末尾 + 水平末尾
 */
@ComponentV2
export struct ColumnEnd {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnEnd() { Text("Hi"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.End,
      alignItems: HorizontalAlign.End,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向两端分布 + 水平居中
 */
@ComponentV2
export struct ColumnSpaceBetween {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnSpaceBetween() { Text("A"); Text("B"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: HorizontalAlign.Center,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向环绕分布 + 水平居中
 */
@ComponentV2
export struct ColumnSpaceAround {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnSpaceAround() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceAround,
      alignItems: HorizontalAlign.Center,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向均分 + 水平居中
 */
@ComponentV2
export struct ColumnSpaceEvenly {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnSpaceEvenly() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceEvenly,
      alignItems: HorizontalAlign.Center,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向居中 + 水平起始
 */
@ComponentV2
export struct ColumnCenterStart {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnCenterStart() { Text("Hi"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.Center,
      alignItems: HorizontalAlign.Start,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向居中 + 水平末尾
 */
@ComponentV2
export struct ColumnCenterEnd {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnCenterEnd() { Text("Hi"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.Center,
      alignItems: HorizontalAlign.End,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向起始 + 水平居中
 */
@ComponentV2
export struct ColumnStartCenter {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnStartCenter() { Text("Hi"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.Start,
      alignItems: HorizontalAlign.Center,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向末尾 + 水平居中
 */
@ComponentV2
export struct ColumnEndCenter {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnEndCenter() { Text("Hi"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.End,
      alignItems: HorizontalAlign.Center,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向两端分布 + 水平起始
 */
@ComponentV2
export struct ColumnSpaceBetweenStart {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnSpaceBetweenStart() { Text("A"); Text("B"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: HorizontalAlign.Start,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向两端分布 + 水平末尾
 */
@ComponentV2
export struct ColumnSpaceBetweenEnd {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnSpaceBetweenEnd() { Text("A"); Text("B"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: HorizontalAlign.End,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向环绕分布 + 水平起始
 */
@ComponentV2
export struct ColumnSpaceAroundStart {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnSpaceAroundStart() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceAround,
      alignItems: HorizontalAlign.Start,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向环绕分布 + 水平末尾
 */
@ComponentV2
export struct ColumnSpaceAroundEnd {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnSpaceAroundEnd() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceAround,
      alignItems: HorizontalAlign.End,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向均分 + 水平起始
 */
@ComponentV2
export struct ColumnSpaceEvenlyStart {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnSpaceEvenlyStart() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceEvenly,
      alignItems: HorizontalAlign.Start,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}

/**
 * 纵向均分 + 水平末尾
 */
@ComponentV2
export struct ColumnSpaceEvenlyEnd {
  /**
   * Column 构造参数
   */
  @Param
  options: ColumnOptions | ColumnOptionsV2 = {};
  /**
   * 宽度
   */
  @Param
  widthValue: Length | undefined = undefined;
  /**
   * 高度
   */
  @Param
  heightValue: Length | undefined = undefined;
  /**
   * 尺寸（对应官方 size 属性）
   */
  @Param
  sizeValue: SizeOptions | undefined = undefined;
  /**
   * 内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大宽高
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 背景颜色
   */
  @Param
  bgColor: ResourceColor | undefined = undefined;
  /**
   * 点击事件
   */
  @Param
  onTap: ((event: ClickEvent) => void) | undefined = undefined;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 渲染布局
   * @returns {void} 无返回值
   * @example
  * ColumnSpaceEvenlyEnd() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    ColumnBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceEvenly,
      alignItems: HorizontalAlign.End,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      sizeValue: this.sizeValue,
      paddingValue: this.paddingValue,
      marginValue: this.marginValue,
      fillMaxSize: this.fillMaxSize,
      bgColor: this.bgColor,
      onTap: this.onTap,
      content: this.content
    });
  }
}
