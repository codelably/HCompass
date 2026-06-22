/**
 * @file 场景二：自适应悬浮导航 + MiniBar
 * @author JunBin.Yang
 *
 * 演示 HdsTabs MiniBar 折叠展开能力，底部悬浮导航栏嵌入迷你控制栏。
 */

import { AppStorageV2, SymbolGlyphModifier } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import {
  HdsBarStyle,
  hdsMaterial,
  HdsNavDestination,
  HdsTabs,
  HdsTabsController,
  HideMode,
  ScrollEffectType,
} from '@kit.UIDesignKit';
import { GlobalInfoModel, StorageKey } from '@core/spatialization';
import { Logger } from '@core/util';

const TAG: string = 'AdaptiveTabView';

const ADAPTIVE_TABS: string[] = ['首页', '发现', '消息', '我的'];
const ADAPTIVE_ICONS: Resource[] = [
  $r('sys.symbol.house_fill'),
  $r('sys.symbol.star_fill'),
  $r('sys.symbol.message_fill'),
  $r('sys.symbol.person_fill'),
];

function buildAdaptiveTabBarStyles(): BottomTabBarStyle[] {
  const styles: BottomTabBarStyle[] = [];
  for (let i = 0; i < ADAPTIVE_TABS.length; i++) {
    styles.push(new BottomTabBarStyle(
      { normal: new SymbolGlyphModifier(ADAPTIVE_ICONS[i]) },
      ADAPTIVE_TABS[i],
    ));
  }
  return styles;
}

@ComponentV2
struct AdaptiveTabView {
  private controller: HdsTabsController = new HdsTabsController();
  private tabBarStyles: BottomTabBarStyle[] = buildAdaptiveTabBarStyles();
  @Local globalInfoModel: GlobalInfoModel =
    AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
  @Local isMiniBar: boolean = true;
  private pathStack?: NavPathStack;
  private scrollers: Scroller[] = [new Scroller(), new Scroller(), new Scroller(), new Scroller()];

  /**
   * 构建 MiniBar 内容（简易音乐播放控制栏）
   */
  @Builder
  miniBarBuilder() {
    Row() {
      Row()
        .width(48)
        .height(48)
        .borderRadius(24)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .margin({ left: 4 })

      Column({ space: 4 }) {
        Text('示例音乐')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Body_S'))
        Text('艺术家名称')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor($r('sys.color.font_secondary'))
          .fontSize($r('sys.float.Caption_M'))
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .padding({ left: 8 })

      Row({ space: 16 }) {
        SymbolGlyph($r('sys.symbol.play_round_triangle_fill'))
          .fontSize($r('sys.float.Title_M'))
          .fontColor([$r('sys.color.font_primary')])
        SymbolGlyph($r('sys.symbol.forward_end_fill'))
          .fontSize($r('sys.float.Title_M'))
          .fontColor([$r('sys.color.font_primary')])
      }
      .padding({ right: 16 })
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
  }

  build() {
    HdsNavDestination() {
      HdsTabs({ controller: this.controller }) {
        Repeat(this.tabBarStyles)
          .each((item: RepeatItem<BottomTabBarStyle>) => {
            TabContent() {
              List({ scroller: this.scrollers[item.index] }) {
                ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], (index: number) => {
                  ListItem() {
                    Row() {
                      Text(`${ADAPTIVE_TABS[item.index]} - 内容项 ${index + 1}`)
                        .fontSize($r('sys.float.Body_M'))
                        .fontColor($r('sys.color.font_primary'))
                        .padding({ left: 16 })
                    }
                    .width('100%')
                    .height(72)
                    .backgroundColor($r('sys.color.comp_background_secondary'))
                    .borderRadius(12)
                    .margin({ bottom: 8 })
                  }
                }, (index: number) => index.toString())
              }
              .width('100%')
              .height('100%')
              .padding({ left: 16, right: 16 })
              .scrollBar(BarState.Off)
              .contentStartOffset(this.globalInfoModel.statusBarHeight + 56)
            }
            .tabBar(item.item)
          })
      }
      .barOverlap(true)
      .vertical(false)
      .barPosition(BarPosition.End)
      .onAttach(() => {
        try {
          this.controller.preloadItems([0, 1, 2, 3]);
        } catch (err) {
          Logger.error(`preloadItems failed: ${(err as BusinessError).message}`, TAG);
        }
      })
      .barFloatingStyle({
        barBottomMargin: this.globalInfoModel.naviIndicatorHeight > 0
          ? this.globalInfoModel.naviIndicatorHeight
          : $r('sys.float.padding_level8'),
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
        },
        miniBar: {
          miniBarBuilder: () => this.miniBarBuilder(),
          onBarStyleChange: (style: HdsBarStyle) => {
            this.isMiniBar = style === HdsBarStyle.COLLAPSE;
          },
        },
      })
    }
    .titleBar({
      content: {
        title: { mainTitle: '自适应悬浮导航' },
      },
      style: {
        scrollEffectOpts: {
          enableScrollEffect: true,
          scrollEffectType: ScrollEffectType.GRADIENT_BLUR,
        },
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
        },
      },
      avoidLayoutSafeArea: true,
      enableComponentSafeArea: false,
    })
    .dynamicHideTitleBar({
      hideTitleArea: true,
      hideStatusBar: true,
      mode: HideMode.SCROLL_UP_TO,
    })
    .bindToScrollable(this.scrollers)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
    })
  }
}

@Builder
export function AdaptiveTabViewBuilder() {
  AdaptiveTabView()
}
