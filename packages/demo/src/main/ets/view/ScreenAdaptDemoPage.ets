import {
  ColumnBase,
  MediumPaddingVerticalScroll,
  P100,
  SpaceHorizontalSmall,
  SpaceVerticalLarge,
  SpaceVerticalSmall
} from "@core/designsystem";
import { bp, BreakpointState, getBreakpointState } from "@core/layoutstate";
import { AppNavDestination } from "@core/components";
import ScreenAdaptDemoViewModel from "../viewmodel/ScreenAdaptDemoViewModel";

/**
 * @file 屏幕适配示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct ScreenAdaptDemoPage {
  /**
   * 屏幕适配示例页 ViewModel
   */
  @Local
  private vm: ScreenAdaptDemoViewModel = new ScreenAdaptDemoViewModel();
  /**
   * 网格示例数据
   */
  private gridItems: number[] = [0, 1, 2, 3, 4, 5];
  /**
   * 断点状态
   */
  @Local
  private breakpointState: BreakpointState = getBreakpointState();
  /**
   * 列表示例数据
   */
  private listItems: number[] = [0, 1, 2, 3];

  /**
   * 构建屏幕适配示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_screen_adapt_title"),
      viewModel: this.vm
    }) {
      this.ScreenAdaptContent();
    }
  }

  /**
   * 屏幕适配示例页内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private ScreenAdaptContent(): void {
    MediumPaddingVerticalScroll() {
      ColumnBase({ widthValue: P100 }) {
        this.SectionTitle($r("app.string.demo_screen_adapt_breakpoint_title"));
        SpaceVerticalSmall();
        this.BreakpointCard();

        SpaceVerticalLarge();

        this.SectionTitle($r("app.string.demo_screen_adapt_grid_section_title"));
        SpaceVerticalSmall();
        this.GridSection();

        SpaceVerticalLarge();

        this.SectionTitle($r("app.string.demo_screen_adapt_list_section_title"));
        SpaceVerticalSmall();
        this.ListSection();

        SpaceVerticalLarge();

        this.SectionTitle($r("app.string.demo_screen_adapt_text_section_title"));
        SpaceVerticalSmall();
        this.TextAdaptSection();

        SpaceVerticalLarge();

        this.SectionTitle($r("app.string.demo_screen_adapt_size_section_title"));
        SpaceVerticalSmall();
        this.SizeAdaptSection();
      };
    };
  }

  /**
   * 区块标题
   * @param {Resource} title - 标题文本
   * @returns {void} 无返回值
   */
  @Builder
  private SectionTitle(title: Resource): void {
    Text(title)
      .fontSize($r("app.float.headline_large"))
      .fontColor($r("app.color.text_primary"));
  }

  /**
   * 网格布局示例
   * @returns {void} 无返回值
   */
  @Builder
  private GridSection(): void {
    Grid() {
      ForEach(this.gridItems, (item: number) => {
        GridItem() {
          this.GridItemCard(item + 1);
        }
      }, (item: number) => `${item}`);
    }
    .columnsTemplate(bp({ sm: "1fr 1fr", md: "1fr 1fr 1fr", lg: "1fr 1fr 1fr 1fr" }))
    .columnsGap($r("app.float.space_padding_small"))
    .rowsGap($r("app.float.space_padding_small"))
    .width(P100);
  }

  /**
   * 列表布局示例（小屏一列，大屏两列）
   * @returns {void} 无返回值
   */
  @Builder
  private ListSection(): void {
    Grid() {
      ForEach(this.listItems, (item: number) => {
        GridItem() {
          this.ListItemCard(item + 1);
        }
      }, (item: number) => `${item}`);
    }
    .columnsTemplate(bp({ sm: "1fr", md: "1fr 1fr", lg: "1fr 1fr" }))
    .columnsGap($r("app.float.space_padding_small"))
    .rowsGap($r("app.float.space_padding_small"))
    .width(P100);
  }

  /**
   * 网格卡片
   * @param {number} index - 序号
   * @returns {void} 无返回值
   */
  @Builder
  private GridItemCard(index: number): void {
    Column() {
      this.CardTitle($r("app.string.demo_screen_adapt_grid_item_format", index));

      SpaceVerticalSmall();

      this.CardDesc($r("app.string.demo_screen_adapt_grid_desc"));
    }
    .width(P100)
    .padding($r("app.float.space_padding_medium"))
    .backgroundColor($r("app.color.bg_white"))
    .borderRadius($r("app.float.radius_medium"));
  }

  /**
   * 列表卡片
   * @param {number} index - 序号
   * @returns {void} 无返回值
   */
  @Builder
  private ListItemCard(index: number): void {
    Column() {
      this.CardTitle($r("app.string.demo_screen_adapt_list_item_format", index));

      SpaceVerticalSmall();

      this.CardDesc($r("app.string.demo_screen_adapt_list_desc"));
    }
    .width(P100)
    .padding($r("app.float.space_padding_medium"))
    .backgroundColor($r("app.color.bg_white"))
    .borderRadius($r("app.float.radius_medium"));
  }

  /**
   * 当前断点信息
   * @returns {void} 无返回值
   */
  @Builder
  private BreakpointCard(): void {
    Column() {
      this.CardTitle($r("app.string.demo_screen_adapt_breakpoint_label"));
      SpaceVerticalSmall();
      this.CardDesc(this.breakpointState.current);
    }
    .width(P100)
    .padding($r("app.float.space_padding_medium"))
    .backgroundColor($r("app.color.bg_white"))
    .borderRadius($r("app.float.radius_medium"));
  }

  /**
   * 文本适配示例
   * @returns {void} 无返回值
   */
  @Builder
  private TextAdaptSection(): void {
    Column() {
      Row() {
        Text($r("app.string.demo_screen_adapt_text_adaptive_label"))
          .fontSize($r("app.float.body_medium"))
          .fontColor($r("app.color.text_subtitle"));

        SpaceHorizontalSmall();

        Text($r("app.string.demo_screen_adapt_text_sample"))
          .fontSize(bp({
            sm: $r("app.float.body_large"),
            md: $r("app.float.headline_large"),
            lg: $r("app.float.display_large")
          }))
          .fontColor($r("app.color.text_primary"))
          .fontWeight(FontWeight.Bold);
      }
      .alignItems(VerticalAlign.Center);
    }
    .width(P100)
    .padding($r("app.float.space_padding_medium"))
    .backgroundColor($r("app.color.bg_white"))
    .borderRadius($r("app.float.radius_medium"));
  }

  /**
   * 尺寸适配示例
   * @returns {void} 无返回值
   */
  @Builder
  private SizeAdaptSection(): void {
    Column() {
      this.CardTitle($r("app.string.demo_screen_adapt_size_title"));

      SpaceVerticalSmall();

      this.CardDesc($r("app.string.demo_screen_adapt_size_desc"));

      SpaceVerticalSmall();

      Row() {
        Text($r("app.string.demo_screen_adapt_size_label", this.getSizeValue()))
          .fontSize($r("app.float.body_medium"))
          .fontColor($r("app.color.text_subtitle"))
          .layoutWeight(1);

        Column() {
        }
        .width(this.getSizeValue())
        .height(this.getSizeValue())
        .backgroundColor($r("app.color.bg_purple_light"))
        .borderRadius($r("app.float.radius_small"));
      }
      .alignItems(VerticalAlign.Center);
    }
    .width(P100)
    .padding($r("app.float.space_padding_medium"))
    .backgroundColor($r("app.color.bg_white"))
    .borderRadius($r("app.float.radius_medium"));
  }

  /**
   * 获取尺寸适配值
   * @returns {string} 尺寸值
   */
  private getSizeValue(): string {
    return bp({ sm: "80vp", md: "96vp", lg: "120vp" });
  }

  /**
   * 卡片标题样式
   * @param {Resource | string} title - 标题文本
   * @returns {void} 无返回值
   */
  @Builder
  private CardTitle(title: Resource | string): void {
    Text(title)
      .fontSize($r("app.float.body_large"))
      .fontColor($r("app.color.text_primary"));
  }

  /**
   * 卡片说明样式
   * @param {Resource | string} text - 说明文本
   * @returns {void} 无返回值
   */
  @Builder
  private CardDesc(text: Resource | string): void {
    Text(text)
      .fontSize($r("app.float.body_medium"))
      .fontColor($r("app.color.text_subtitle"));
  }
}
