/**
 * @file 场景一：首眼沉浸光感视图
 * @author JunBin.Yang
 *
 * 演示 HdsNavDestination + HdsTabs 实现底部悬浮导航沉浸光感，
 * 配合 HdsNavigation 标题栏渐变模糊和滚动显隐效果。
 */

import { AppStorageV2, ComponentContent, LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import {
  HdsAnimationMode,
  hdsMaterial,
  HdsNavDestination,
  HdsNavigation,
  HdsNavigationMenuContentOptions,
  HdsNavigationTitleMode,
  HdsTabs,
  HdsTabsController,
  HideMode,
  ScrollEffectType,
  TextStyleMode,
} from '@kit.UIDesignKit';
import { GlobalInfoModel, MaterialUtil, StorageKey } from '@core/spatialization';
import { Logger } from '@core/util';
import { MaterialLevelItem, materialLevelMenu } from '../component/MaterialLevelMenu';

const MENU_ID: string = 'SpatializationLevelMenu';

const TAG: string = 'ImmersiveLightView';

const DEMO_ITEMS: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];

const TAB_TITLES: string[] = ['推荐', '关注', '视频', '直播', '购物'];
const TAB_ICONS: Resource[] = [
  $r('sys.symbol.house_fill'),
  $r('sys.symbol.person_2_fill'),
  $r('sys.symbol.play_fill'),
  $r('sys.symbol.video_fill'),
  $r('sys.symbol.bag_fill'),
];

/** 构建 Tab 栏样式列表 */
function buildTabBarStyles(): BottomTabBarStyle[] {
  const styles: BottomTabBarStyle[] = [];
  for (let i = 0; i < TAB_TITLES.length; i++) {
    styles.push(new BottomTabBarStyle(
      { normal: new SymbolGlyphModifier(TAB_ICONS[i]) },
      TAB_TITLES[i],
    ));
  }
  return styles;
}

@ComponentV2
struct TabContentView {
  @Param @Require pageIndex: number;
  @Event onScrollOffset?: (yOffset: number) => void;
  private scroller: Scroller = new Scroller();
  @Local globalInfoModel: GlobalInfoModel =
    AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
  @Local materialLevel: MaterialLevelItem =
    AppStorageV2.connect(MaterialLevelItem, StorageKey.MATERIAL_LEVEL, () => new MaterialLevelItem()) ??
      new MaterialLevelItem();

  private menus: HdsNavigationMenuContentOptions = {
    value: [
      {
        content: {
          label: '光感等级',
          icon: $r('sys.symbol.gearshape_fill'),
          type: TextStyleMode.NORMAL,
          componentId: MENU_ID,
          action: () => {
            try {
              const uiCtx = this.getUIContext();
              const contentNode = new ComponentContent(uiCtx, wrapBuilder(materialLevelMenu));
              uiCtx.getPromptAction().openMenu(
                contentNode,
                { id: MENU_ID },
                MaterialUtil.getMaterialOptions<MenuOptions>(
                  { mask: false, backgroundBlurStyle: BlurStyle.COMPONENT_THICK }
                ) as MenuOptions,
              ).catch((err: BusinessError) => {
                Logger.error(`openMenu failed: ${err.message}`, TAG);
              });
            } catch (err) {
              Logger.error(`openMenu error: ${(err as BusinessError).message}`, TAG);
            }
          },
        },
      },
    ],
  };

  build() {
    HdsNavigation() {
      List({ scroller: this.scroller }) {
        ForEach(DEMO_ITEMS, (index: number) => {
          ListItem() {
            Row() {
              Text(`内容项 ${index + 1} - Tab ${this.pageIndex + 1}`)
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_primary'))
                .padding({ left: 16, right: 16 })
            }
            .width('100%')
            .height(80)
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
      .onScrollFrameBegin((offset: number) => {
        this.onScrollOffset?.(offset);
        return { offsetRemain: offset };
      })
    }
    .titleBar({
      content: {
        menu: this.menus,
      },
      style: {
        scrollEffectOpts: {
          enableScrollEffect: true,
          scrollEffectType: ScrollEffectType.GRADIENT_BLUR,
          blurEffectiveEndOffset: LengthMetrics.vp(this.globalInfoModel.statusBarHeight + 56),
        },
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: this.materialLevel.level,
        },
      },
      avoidLayoutSafeArea: true,
      enableComponentSafeArea: false,
    })
    .titleMode(HdsNavigationTitleMode.MINI)
    .hideBackButton(true)
    .dynamicHideTitleBar({
      hideTitleArea: true,
      hideStatusBar: true,
      mode: HideMode.SCROLL_UP_TO,
    })
    .bindToScrollable([this.scroller])
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
  }
}

@ComponentV2
struct ImmersiveLightView {
  private controller: HdsTabsController = new HdsTabsController();
  private tabBarStyles: BottomTabBarStyle[] = buildTabBarStyles();
  @Local globalInfoModel: GlobalInfoModel =
    AppStorageV2.connect(GlobalInfoModel, StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
  @Local materialLevel: MaterialLevelItem =
    AppStorageV2.connect(MaterialLevelItem, StorageKey.MATERIAL_LEVEL, () => new MaterialLevelItem()) ??
      new MaterialLevelItem();
  private pathStack?: NavPathStack;
  private isScrollUp: boolean = false;

  /**
   * 根据滚动偏移量控制底部 Tab 动画显隐
   * @param yOffset 滚动偏移量（正值向上滚动）
   */
  private handleScrollOffset(yOffset: number): void {
    if (!this.globalInfoModel.needDynamicHideBar) {
      return;
    }
    if (yOffset > 0 && !this.isScrollUp) {
      this.isScrollUp = true;
      this.controller.applyHideAnimation(HdsAnimationMode.SCROLL_ANIMATION);
    } else if (yOffset < 0 && this.isScrollUp) {
      this.isScrollUp = false;
      this.controller.applyShowAnimation(HdsAnimationMode.SCROLL_ANIMATION);
    }
  }

  build() {
    HdsNavDestination() {
      HdsTabs({ controller: this.controller }) {
        Repeat(this.tabBarStyles)
          .each((item: RepeatItem<BottomTabBarStyle>) => {
            TabContent() {
              TabContentView({
                pageIndex: item.index,
                onScrollOffset: (yOffset: number) => {
                  this.handleScrollOffset(yOffset);
                },
              })
            }
            .tabBar(item.item)
          })
      }
      .scrollable(false)
      .barOverlap(true)
      .vertical(false)
      .barPosition(BarPosition.End)
      .onAttach(() => {
        try {
          this.controller.preloadItems([0, 1, 2, 3, 4]);
        } catch (err) {
          Logger.error(`preloadItems failed: ${(err as BusinessError).message}`, TAG);
        }
      })
      .barFloatingStyle({
        barBottomMargin: this.globalInfoModel.naviIndicatorHeight > 0
          ? this.globalInfoModel.naviIndicatorHeight
          : $r('sys.float.padding_level8'),
        adaptToHandedness: true,
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: this.materialLevel.level,
        },
      })
    }
    .dynamicHideTitleBar({
      hideTitleArea: true,
      hideStatusBar: true,
      mode: HideMode.SCROLL_UP_TO,
    })
    .hideTitleBar(true)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
    })
  }
}

@Builder
export function ImmersiveLightViewBuilder() {
  ImmersiveLightView()
}
