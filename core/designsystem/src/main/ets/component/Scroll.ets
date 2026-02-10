import { P100 } from "../constants/LayoutPercent";

/**
 * @file 滚动布局组件
 * @author Joker.X
 */

/**
 * 垂直滚动布局
 */
@ComponentV2
export struct VerticalScroll {
  /**
   * 滚动控制器
   */
  @Param
  scroller: Scroller = new Scroller();
  /**
   * 内容内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大尺寸
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 是否填充最大宽度（仅当 fillMaxSize 为 false 生效）
   */
  @Param
  fillMaxWidth: boolean = true;
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
   * 滚动条状态
   */
  @Param
  scrollBarState: BarState = BarState.Off;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 构建垂直滚动布局
   * @returns {void} 无返回值
   */
  build(): void {
    Scroll(this.scroller) {
      if (this.content) {
        this.content();
      }
    }
    .scrollBar(this.scrollBarState)
    .attributeModifier(this.buildScrollModifier());
  }

  /**
   * 构建滚动容器属性修饰器
   * @returns {AttributeModifier<ScrollAttribute>} 滚动容器属性修饰器
   */
  private buildScrollModifier(): AttributeModifier<ScrollAttribute> {
    const fillMaxSize = this.fillMaxSize;
    const fillMaxWidth = this.fillMaxWidth;
    const width = this.widthValue;
    const height = this.heightValue;
    const padding = this.paddingValue;
    const margin = this.marginValue;

    return {
      applyNormalAttribute: (instance: ScrollAttribute): void => {
        if (fillMaxSize) {
          instance.size({ width: P100, height: P100 });
        } else {
          if (width !== undefined) {
            instance.width(width);
          } else if (fillMaxWidth) {
            instance.width(P100);
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
      }
    };
  }
}

/**
 * 带小内边距的垂直滚动布局
 */
@ComponentV2
export struct SmallPaddingVerticalScroll {
  /**
   * 滚动控制器
   */
  @Param
  scroller: Scroller = new Scroller();
  /**
   * 是否填充最大尺寸
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 是否填充最大宽度
   */
  @Param
  fillMaxWidth: boolean = true;
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
   * 滚动条状态
   */
  @Param
  scrollBarState: BarState = BarState.Off;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 构建带小内边距的垂直滚动布局
   * @returns {void} 无返回值
   */
  build(): void {
    VerticalScroll({
      scroller: this.scroller,
      fillMaxSize: this.fillMaxSize,
      fillMaxWidth: this.fillMaxWidth,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      scrollBarState: this.scrollBarState,
      paddingValue: $r("app.float.space_padding_small"),
      content: this.content
    });
  }
}

/**
 * 带中等内边距的垂直滚动布局
 */
@ComponentV2
export struct MediumPaddingVerticalScroll {
  /**
   * 滚动控制器
   */
  @Param
  scroller: Scroller = new Scroller();
  /**
   * 是否填充最大尺寸
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 是否填充最大宽度
   */
  @Param
  fillMaxWidth: boolean = true;
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
   * 滚动条状态
   */
  @Param
  scrollBarState: BarState = BarState.Off;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 构建带中等内边距的垂直滚动布局
   * @returns {void} 无返回值
   */
  build(): void {
    VerticalScroll({
      scroller: this.scroller,
      fillMaxSize: this.fillMaxSize,
      fillMaxWidth: this.fillMaxWidth,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      scrollBarState: this.scrollBarState,
      paddingValue: $r("app.float.space_padding_medium"),
      content: this.content
    });
  }
}

/**
 * 带大内边距的垂直滚动布局
 */
@ComponentV2
export struct LargePaddingVerticalScroll {
  /**
   * 滚动控制器
   */
  @Param
  scroller: Scroller = new Scroller();
  /**
   * 是否填充最大尺寸
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 是否填充最大宽度
   */
  @Param
  fillMaxWidth: boolean = true;
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
   * 滚动条状态
   */
  @Param
  scrollBarState: BarState = BarState.Off;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 构建带大内边距的垂直滚动布局
   * @returns {void} 无返回值
   */
  build(): void {
    VerticalScroll({
      scroller: this.scroller,
      fillMaxSize: this.fillMaxSize,
      fillMaxWidth: this.fillMaxWidth,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      scrollBarState: this.scrollBarState,
      paddingValue: $r("app.float.space_padding_large"),
      content: this.content
    });
  }
}

/**
 * 水平滚动布局
 */
@ComponentV2
export struct HorizontalScroll {
  /**
   * 滚动控制器
   */
  @Param
  scroller: Scroller = new Scroller();
  /**
   * 内容内边距
   */
  @Param
  paddingValue: Padding | Length | LocalizedPadding | undefined = undefined;
  /**
   * 外边距
   */
  @Param
  marginValue: Margin | Length | LocalizedMargin | undefined = undefined;
  /**
   * 是否填充最大尺寸
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 是否填充最大宽度
   */
  @Param
  fillMaxWidth: boolean = true;
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
   * 滚动条状态
   */
  @Param
  scrollBarState: BarState = BarState.Off;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 构建水平滚动布局
   * @returns {void} 无返回值
   */
  build(): void {
    Scroll(this.scroller) {
      if (this.content) {
        this.content();
      }
    }
    .scrollBar(this.scrollBarState)
    .attributeModifier(this.buildScrollModifier());
  }

  /**
   * 构建滚动容器属性修饰器
   * @returns {AttributeModifier<ScrollAttribute>} 滚动容器属性修饰器
   */
  private buildScrollModifier(): AttributeModifier<ScrollAttribute> {
    const fillMaxSize = this.fillMaxSize;
    const fillMaxWidth = this.fillMaxWidth;
    const width = this.widthValue;
    const height = this.heightValue;
    const padding = this.paddingValue;
    const margin = this.marginValue;

    return {
      applyNormalAttribute: (instance: ScrollAttribute): void => {
        if (fillMaxSize) {
          instance.size({ width: P100, height: P100 });
        } else {
          if (width !== undefined) {
            instance.width(width);
          } else if (fillMaxWidth) {
            instance.width(P100);
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
      }
    };
  }
}

/**
 * 带小内边距的水平滚动布局
 */
@ComponentV2
export struct SmallPaddingHorizontalScroll {
  /**
   * 滚动控制器
   */
  @Param
  scroller: Scroller = new Scroller();
  /**
   * 是否填充最大尺寸
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 是否填充最大宽度
   */
  @Param
  fillMaxWidth: boolean = true;
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
   * 滚动条状态
   */
  @Param
  scrollBarState: BarState = BarState.Off;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 构建带小内边距的水平滚动布局
   * @returns {void} 无返回值
   */
  build(): void {
    HorizontalScroll({
      scroller: this.scroller,
      fillMaxSize: this.fillMaxSize,
      fillMaxWidth: this.fillMaxWidth,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      scrollBarState: this.scrollBarState,
      paddingValue: $r("app.float.space_padding_small"),
      content: this.content
    });
  }
}

/**
 * 带中等内边距的水平滚动布局
 */
@ComponentV2
export struct MediumPaddingHorizontalScroll {
  /**
   * 滚动控制器
   */
  @Param
  scroller: Scroller = new Scroller();
  /**
   * 是否填充最大尺寸
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 是否填充最大宽度
   */
  @Param
  fillMaxWidth: boolean = true;
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
   * 滚动条状态
   */
  @Param
  scrollBarState: BarState = BarState.Off;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 构建带中等内边距的水平滚动布局
   * @returns {void} 无返回值
   */
  build(): void {
    HorizontalScroll({
      scroller: this.scroller,
      fillMaxSize: this.fillMaxSize,
      fillMaxWidth: this.fillMaxWidth,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      scrollBarState: this.scrollBarState,
      paddingValue: $r("app.float.space_padding_medium"),
      content: this.content
    });
  }
}

/**
 * 带大内边距的水平滚动布局
 */
@ComponentV2
export struct LargePaddingHorizontalScroll {
  /**
   * 滚动控制器
   */
  @Param
  scroller: Scroller = new Scroller();
  /**
   * 是否填充最大尺寸
   */
  @Param
  fillMaxSize: boolean = false;
  /**
   * 是否填充最大宽度
   */
  @Param
  fillMaxWidth: boolean = true;
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
   * 滚动条状态
   */
  @Param
  scrollBarState: BarState = BarState.Off;
  /**
   * 内容构建函数
   */
  @BuilderParam
  content: CustomBuilder;

  /**
   * 构建带大内边距的水平滚动布局
   * @returns {void} 无返回值
   */
  build(): void {
    HorizontalScroll({
      scroller: this.scroller,
      fillMaxSize: this.fillMaxSize,
      fillMaxWidth: this.fillMaxWidth,
      widthValue: this.widthValue,
      heightValue: this.heightValue,
      scrollBarState: this.scrollBarState,
      paddingValue: $r("app.float.space_padding_large"),
      content: this.content
    });
  }
}
