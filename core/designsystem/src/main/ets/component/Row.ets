import { P100 } from "../constants/LayoutPercent";

/**
 * @file 通用 Row 布局简化组件
 * @author Joker.X
 */

/**
 * 通用 Row 布局（保留官方 Row 能力）
 */
@ComponentV2
export struct RowBase {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
  /**
   * 主轴对齐方式
   */
  @Param
  justifyContent: FlexAlign = FlexAlign.Start;
  /**
   * 交叉轴对齐方式
   */
  @Param
  alignItems: VerticalAlign = VerticalAlign.Center;
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
   * 构建通用 Row 布局
   * @returns {void} 无返回值
   * @example
  * RowBase({ fillMaxSize: true }) { Text("Hi"); }
   */
  build(): void {
    Row(this.options) {
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
   * @returns {AttributeModifier<RowAttribute>} Row 属性修饰器
   */
  private buildCommonModifier(): AttributeModifier<RowAttribute> {
    const size = this.sizeValue;
    const fillMaxSize = this.fillMaxSize;
    const width = this.widthValue;
    const height = this.heightValue;
    const padding = this.paddingValue;
    const margin = this.marginValue;
    const backgroundColor = this.bgColor;
    const onClick = this.onTap;

    return {
      applyNormalAttribute: (instance: RowAttribute): void => {
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
 * 横向居中 + 垂直居中
 */
@ComponentV2
export struct RowCenter {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowCenter() { Text("Hi"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.Center,
      alignItems: VerticalAlign.Center,
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
 * 横向起始 + 垂直居中
 */
@ComponentV2
export struct RowStartCenter {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowStartCenter() { Text("Hi"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.Start,
      alignItems: VerticalAlign.Center,
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
 * 横向末尾 + 垂直居中
 */
@ComponentV2
export struct RowEndCenter {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowEndCenter() { Text("Hi"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.End,
      alignItems: VerticalAlign.Center,
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
 * 横向两端分布 + 垂直居中
 */
@ComponentV2
export struct RowSpaceBetweenCenter {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowSpaceBetweenCenter() { Text("A"); Text("B"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: VerticalAlign.Center,
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
 * 横向环绕分布 + 垂直居中
 */
@ComponentV2
export struct RowSpaceAroundCenter {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowSpaceAroundCenter() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceAround,
      alignItems: VerticalAlign.Center,
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
 * 横向均分 + 垂直居中
 */
@ComponentV2
export struct RowSpaceEvenlyCenter {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowSpaceEvenlyCenter() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceEvenly,
      alignItems: VerticalAlign.Center,
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
 * 横向居中 + 垂直顶部
 */
@ComponentV2
export struct RowCenterTop {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowCenterTop() { Text("Hi"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.Center,
      alignItems: VerticalAlign.Top,
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
 * 横向居中 + 垂直底部
 */
@ComponentV2
export struct RowCenterBottom {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowCenterBottom() { Text("Hi"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.Center,
      alignItems: VerticalAlign.Bottom,
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
 * 横向起始 + 垂直顶部
 */
@ComponentV2
export struct RowStartTop {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowStartTop() { Text("Hi"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.Start,
      alignItems: VerticalAlign.Top,
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
 * 横向起始 + 垂直底部
 */
@ComponentV2
export struct RowStartBottom {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowStartBottom() { Text("Hi"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.Start,
      alignItems: VerticalAlign.Bottom,
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
 * 横向末尾 + 垂直顶部
 */
@ComponentV2
export struct RowEndTop {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowEndTop() { Text("Hi"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.End,
      alignItems: VerticalAlign.Top,
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
 * 横向末尾 + 垂直底部
 */
@ComponentV2
export struct RowEndBottom {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowEndBottom() { Text("Hi"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.End,
      alignItems: VerticalAlign.Bottom,
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
 * 横向两端分布 + 垂直顶部
 */
@ComponentV2
export struct RowSpaceBetweenTop {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowSpaceBetweenTop() { Text("A"); Text("B"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: VerticalAlign.Top,
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
 * 横向两端分布 + 垂直底部
 */
@ComponentV2
export struct RowSpaceBetweenBottom {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowSpaceBetweenBottom() { Text("A"); Text("B"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: VerticalAlign.Bottom,
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
 * 横向环绕分布 + 垂直顶部
 */
@ComponentV2
export struct RowSpaceAroundTop {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowSpaceAroundTop() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceAround,
      alignItems: VerticalAlign.Top,
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
 * 横向环绕分布 + 垂直底部
 */
@ComponentV2
export struct RowSpaceAroundBottom {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowSpaceAroundBottom() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceAround,
      alignItems: VerticalAlign.Bottom,
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
 * 横向均分 + 垂直顶部
 */
@ComponentV2
export struct RowSpaceEvenlyTop {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowSpaceEvenlyTop() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceEvenly,
      alignItems: VerticalAlign.Top,
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
 * 横向均分 + 垂直底部
 */
@ComponentV2
export struct RowSpaceEvenlyBottom {
  /**
   * Row 构造参数
   */
  @Param
  options: RowOptions | RowOptionsV2 = {};
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
  * RowSpaceEvenlyBottom() { Text("A"); Text("B"); Text("C"); }
   */
  build(): void {
    RowBase({
      options: this.options,
      justifyContent: FlexAlign.SpaceEvenly,
      alignItems: VerticalAlign.Bottom,
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
