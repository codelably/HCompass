import { IBestCell, IBestCellGroup } from "@core/ibestui";
import {
  ColumnBase,
  MediumPaddingVerticalScroll,
  P100,
  P90,
  columnCenter,
  size,
  SpaceVerticalLarge,
  SpaceVerticalSmall
} from "@core/designsystem";
import { getWindowSafeAreaState, WindowSafeAreaState } from "@core/layoutstate";
import { AppNavDestination } from "@core/components";
import { AboutLinkItem } from "../models/AboutLinkItem";
import AboutViewModel from "../viewmodel/AboutViewModel";

/**
 * @file 关于页面视图
 * @author Joker.X
 */
@ComponentV2
export struct AboutPage {
  /**
   * 关于页面 ViewModel
   */
  @Local
  private vm: AboutViewModel = new AboutViewModel();
  /**
   * 窗口安全区状态
   */
  @Local
  private windowSafeAreaState: WindowSafeAreaState = getWindowSafeAreaState();

  /**
   * 构建关于页面
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.about"),
      viewModel: this.vm,
      paddingValue: {
        top: this.windowSafeAreaState.topInset,
        left: this.windowSafeAreaState.leftInset,
        right: this.windowSafeAreaState.rightInset,
      }
    }) {
      this.AboutContent();
    }
  }

  /**
   * 关于页面内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private AboutContent() {
    MediumPaddingVerticalScroll() {
      ColumnBase({ widthValue: P100 }) {
        this.AboutHeader();
        SpaceVerticalLarge();
        this.AboutLinks();
      };
    };
  }

  /**
   * 关于页面头部
   * @returns {void} 无返回值
   */
  @Builder
  private AboutHeader(): void {
    Column() {
      Image($r("app.media.ic_logo"))
        .attributeModifier(size(72))
        .objectFit(ImageFit.Contain);

      SpaceVerticalSmall();

      Text($r("app.string.app_name"))
        .fontSize($r("app.float.headline_medium"))
        .fontColor($r("app.color.text_primary"))
        .fontWeight(FontWeight.Bold);

      SpaceVerticalSmall();

      Text($r("app.string.main_about_desc"))
        .fontSize($r("app.float.body_medium"))
        .fontColor($r("app.color.text_subtitle"))
        .textAlign(TextAlign.Center);
    }
    .attributeModifier(columnCenter())
    .width(P100)
    .padding($r("app.float.space_padding_medium"))
    .backgroundColor($r("app.color.bg_white"))
    .borderRadius($r("app.float.radius_medium"));
  }

  /**
   * 关于页面链接区
   * @returns {void} 无返回值
   */
  @Builder
  private AboutLinks(): void {
    IBestCellGroup({ inset: true, outerMargin: 0 }) {
      ForEach(this.vm.links, (item: AboutLinkItem, index: number) => {
        IBestCell({
          title: item.title,
          label: item.url,
          isLink: true,
          leftContentWidth: P90,
          hasBorder: index !== this.vm.links.length - 1,
          onCellClick: () => this.vm.openUrl(item.url)
        });
      }, (_item: AboutLinkItem, index: number) => `${index}`);
    };
  }
}
