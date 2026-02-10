import { IBestButton, IBestCell, IBestCellGroup, IBestField, IBestFieldValueType } from "@core/ibestui";
import {
  ColumnBase, MediumPaddingVerticalScroll, P100, SpaceVerticalLarge
} from "@core/designsystem";
import { AppNavDestination } from "@core/components";
import LocalStorageViewModel from "../viewmodel/LocalStorageViewModel";

/**
 * @file 本地存储示例页视图
 * @author Joker.X
 */
@ComponentV2
export struct LocalStoragePage {
  /**
   * 本地存储示例页 ViewModel
   */
  @Local
  private vm: LocalStorageViewModel = new LocalStorageViewModel();

  /**
   * 构建本地存储示例页
   * @returns {void} 无返回值
   */
  build() {
    AppNavDestination({
      title: $r("app.string.demo_local_storage_title"),
      viewModel: this.vm
    }) {
      this.LocalStorageContent();
    }
  }

  /**
   * 本地存储示例页内容视图
   * @returns {void} 无返回值
   */
  @Builder
  private LocalStorageContent() {
    MediumPaddingVerticalScroll() {
      ColumnBase({ widthValue: P100 }) {
        this.InputSection();
        SpaceVerticalLarge();
        this.ActionSection();
        SpaceVerticalLarge();
        this.ResultSection();
      };
    };
  }

  /**
   * 输入区域
   * @returns {void} 无返回值
   */
  @Builder
  private InputSection(): void {
    IBestCellGroup({ inset: true, outerMargin: 0 }) {
      IBestField({
        value: this.vm.accountInput,
        label: $r("app.string.demo_local_storage_account_label"),
        placeholder: $r("app.string.demo_local_storage_account_placeholder"),
        onChange: (value: IBestFieldValueType): void => {
          this.vm.updateAccountInput(this.normalizeFieldValue(value));
        }
      });
    };
  }

  /**
   * 操作区域
   * @returns {void} 无返回值
   */
  @Builder
  private ActionSection(): void {
    IBestButton({
      text: $r("app.string.demo_local_storage_action_save"),
      round: true,
      type: "primary",
      buttonSize: "normal",
      btnWidth: P100,
      onBtnClick: (): void => {
        void this.vm.saveAccount();
      }
    });

    SpaceVerticalLarge();

    IBestButton({
      text: $r("app.string.demo_local_storage_action_load"),
      round: true,
      buttonSize: "normal",
      btnWidth: P100,
      onBtnClick: (): void => {
        void this.vm.loadAccount();
      }
    });
  }

  /**
   * 结果区域
   * @returns {void} 无返回值
   */
  @Builder
  private ResultSection(): void {
    IBestCellGroup({ inset: true, outerMargin: 0 }) {
      IBestCell({
        title: $r("app.string.demo_local_storage_account_label"),
        value: this.getDisplayValue(this.vm.storedAccount),
        hasBorder: false
      });
    };
  }

  /**
   * 规范化输入框值为字符串
   * @param {IBestFieldValueType} value - 输入框值
   * @returns {string} 处理后的字符串
   */
  private normalizeFieldValue(value: IBestFieldValueType): string {
    if (typeof value === "string" || typeof value === "number") {
      return `${value}`;
    }
    return "";
  }

  /**
   * 获取展示值
   * @param {string} value - 真实值
   * @returns {ResourceStr} 展示文本
   */
  private getDisplayValue(value: string): ResourceStr {
    const textValue: string = value.trim();
    return textValue.length > 0 ? textValue : $r("app.string.demo_local_storage_value_empty");
  }
}
