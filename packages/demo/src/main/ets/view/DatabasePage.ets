import {
  IBestButton,
  IBestCell,
  IBestCellGroup,
  IBestEmpty,
  IBestField,
  IBestFieldValueType,
  IBestIcon,
  IBestSwipeCell
} from "@core/ibestui";
import {
  ColumnBase,
  MediumPaddingVerticalScroll,
  P100,
  RowStartCenter,
  SpaceVerticalLarge,
  SpaceVerticalMedium,
} from "@core/designsystem";
import { AppNavDestination } from "@core/components";
import DatabaseViewModel from "../viewmodel/DatabaseViewModel";
import { DemoEntity } from "../models/DemoEntity";

/**
 * @file 数据库示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct DatabasePage {
  /**
   * 数据库示例页 ViewModel
   */
  @Local
  private vm: DatabaseViewModel = new DatabaseViewModel();
  /**
   * 滚动控制器
   */
  private scroller: Scroller = new Scroller();

  /**
   * 构建数据库示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_database_title"),
      viewModel: this.vm
    }) {
      this.DatabaseContent();
    }
  }

  /**
   * 数据库示例页内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private DatabaseContent() {
    MediumPaddingVerticalScroll({ scroller: this.scroller }) {
      ColumnBase({ widthValue: P100 }) {
        this.InputSection();
        SpaceVerticalLarge();
        this.ListSection();
      };
    };
  }

  /**
   * 输入区域
   * @returns {void} 无返回值
   */
  @Builder
  private InputSection(): void {
    ColumnBase({ widthValue: P100 }) {
      IBestCellGroup({ inset: true, outerMargin: 0 }) {
        IBestField({
          value: this.vm.titleInput,
          label: $r("app.string.demo_database_title_label"),
          placeholder: $r("app.string.demo_database_title_placeholder"),
          onChange: (value: IBestFieldValueType): void => {
            this.vm.updateTitleInput(value.toString());
          }
        });
        IBestField({
          value: this.vm.descInput,
          label: $r("app.string.demo_database_desc_label"),
          placeholder: $r("app.string.demo_database_desc_placeholder"),
          hasBorder: false,
          onChange: (value: IBestFieldValueType): void => {
            this.vm.updateDescInput(value.toString());
          }
        });
      };

      SpaceVerticalMedium();

      RowStartCenter() {
        IBestButton({
          text: $r("app.string.demo_database_action_save"),
          type: "primary",
          buttonSize: "large",
          round: true,
          disabled: this.vm.loading,
          btnWidth: P100,
          onBtnClick: (): void => {
            void this.vm.save();
          }
        });
      };
    };
  }

  /**
   * 列表区域
   * @returns {void} 无返回值
   */
  @Builder
  private ListSection(): void {
    if (this.vm.items.length === 0) {
      IBestEmpty({ description: $r("app.string.demo_database_empty") })
        .margin({ top: $r("app.float.space_vertical_large") });
    } else {
      IBestCellGroup({ inset: true, outerMargin: 0 }) {
        ForEach(this.vm.items, (item: DemoEntity, index: number) => {
          this.DatabaseItem(item);
        }, (item: DemoEntity, index: number) => JSON.stringify(item));
      }
    }
  }

  /**
   * 渲染单条记录
   * @param {DemoEntity} item - 记录数据
   * @returns {void} 无返回值
   */
  @Builder
  private DatabaseItem(item: DemoEntity): void {
    IBestSwipeCell({
      defaultContent: (): void => this.SwipeCellContent(item),
      rightContent: (): void => this.SwipeCellActions(item)
    });
  }

  /**
   * 构建滑动单元格内容
   * @param {DemoEntity} item - 记录数据
   * @returns {void} 无返回值
   */
  @Builder
  private SwipeCellContent(item: DemoEntity): void {
    IBestCell({
      title: this.getItemTitle(item),
      label: item.description ?? "",
      isLink: true,
      hasBorder: false,
      onCellClick: (): void => {
        this.vm.selectItem(item);
      }
    });
  }

  /**
   * 构建滑动单元格操作区
   * @param {DemoEntity} item - 记录数据
   * @returns {void} 无返回值
   */
  @Builder
  private SwipeCellActions(item: DemoEntity): void {
    Row() {
      IBestIcon({
        name: "delete-o",
        iconSize: 20,
        onIconClick: (): void => {
          if (this.vm.loading) {
            return;
          }
          void this.vm.delete(item.id ?? 0);
        }
      });
    }
    .padding($r("app.float.space_padding_small"))
    .backgroundColor($r("app.color.bg_white"))
    .borderRadius(100)
    .margin({ left: $r("app.float.space_horizontal_small") });
  }

  /**
   * 获取展示标题
   * @param {DemoEntity} item - 记录数据
   * @returns {ResourceStr} 标题文本
   */
  private getItemTitle(item: DemoEntity): ResourceStr {
    const title: string = item.title?.trim() ?? "";
    return title.length > 0 ? title : $r("app.string.demo_database_untitled");
  }
}
