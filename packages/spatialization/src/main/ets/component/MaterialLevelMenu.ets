/**
 * @file 沉浸光感等级切换菜单组件
 * @author JunBin.Yang
 */

import { AppStorageV2, LengthMetrics, SymbolGlyphModifier } from '@kit.ArkUI';
import { hdsMaterial } from '@kit.UIDesignKit';
import { StorageKey } from '@core/spatialization';

/** 等级选项数据 */
@ObservedV2
export class MaterialLevelItem {
  public title: string = '';
  @Trace public level: hdsMaterial.MaterialLevel = hdsMaterial.MaterialLevel.GENTLE;
}

const LEVEL_OPTIONS: MaterialLevelItem[] = (() => {
  const strong = new MaterialLevelItem();
  strong.title = '强';
  strong.level = hdsMaterial.MaterialLevel.EXQUISITE;

  const balanced = new MaterialLevelItem();
  balanced.title = '均衡';
  balanced.level = hdsMaterial.MaterialLevel.GENTLE;

  const weak = new MaterialLevelItem();
  weak.title = '弱';
  weak.level = hdsMaterial.MaterialLevel.SMOOTH;

  return [strong, balanced, weak];
})();

@ComponentV2
struct MaterialLevelMenuComponent {
  @Local currentLevel: MaterialLevelItem =
    AppStorageV2.connect(MaterialLevelItem, StorageKey.MATERIAL_LEVEL, () => new MaterialLevelItem()) ??
      new MaterialLevelItem();
  private checkIcon: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.checkmark'));

  build() {
    Menu() {
      ForEach(LEVEL_OPTIONS, (item: MaterialLevelItem) => {
        MenuItem({
          content: item.title,
          symbolEndIcon: this.currentLevel.level === item.level ? this.checkIcon : undefined,
        })
          .onChange((selected: boolean) => {
            if (selected) {
              this.currentLevel.level = item.level;
            }
          });
      }, (item: MaterialLevelItem) => item.level.toString())
    }
    .backgroundColor(Color.Transparent)
    .width(224)
    .menuItemDivider({
      strokeWidth: LengthMetrics.px(1),
      color: $r('sys.color.comp_divider'),
      startMargin: LengthMetrics.vp(16),
    });
  }
}

@Builder
export function materialLevelMenu() {
  MaterialLevelMenuComponent()
}
