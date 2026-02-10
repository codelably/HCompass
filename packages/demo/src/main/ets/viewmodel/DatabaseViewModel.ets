import { BaseViewModel } from "@core/base";
import { IDemoRepository } from "../services/IDemoRepository";
import { DemoRepositoryImpl } from "../services/DemoRepositoryImpl";
import { DemoEntity } from "../models/DemoEntity";

/**
 * @file 数据库示例页 ViewModel
 * @author Joker.X
 */
@ObservedV2
export default class DatabaseViewModel extends BaseViewModel {
  /**
   * Demo 仓库
   */
  private demoRepository: IDemoRepository = new DemoRepositoryImpl();
  /**
   * 标题输入
   */
  @Trace
  titleInput: string = "";
  /**
   * 描述输入
   */
  @Trace
  descInput: string = "";
  /**
   * 当前编辑的记录 ID（0 表示新增）
   */
  @Trace
  editingId: number = 0;
  /**
   * 数据列表
   */
  @Trace
  items: DemoEntity[] = [];
  /**
   * 操作中状态
   */
  @Trace
  loading: boolean = false;

  /**
   * 页面出现前加载列表
   * @returns {void} 无返回值
   */
  aboutToAppear(): void {
    void this.refreshList();
  }

  /**
   * 更新标题输入
   * @param {string} value - 输入内容
   * @returns {void} 无返回值
   */
  updateTitleInput(value: string): void {
    this.titleInput = value;
  }

  /**
   * 更新描述输入
   * @param {string} value - 输入内容
   * @returns {void} 无返回值
   */
  updateDescInput(value: string): void {
    this.descInput = value;
  }

  /**
   * 选择记录进行编辑
   * @param {DemoEntity} item - 记录数据
   * @returns {void} 无返回值
   */
  selectItem(item: DemoEntity): void {
    this.editingId = item.id ?? 0;
    this.titleInput = item.title ?? "";
    this.descInput = item.description ?? "";
  }

  /**
   * 保存记录（新增或更新）
   * @returns {Promise<void>} Promise<void>
   */
  async save(): Promise<void> {
    await this.runWithLoading(async (): Promise<void> => {
      if (this.editingId > 0) {
        await this.updateById(this.editingId);
      } else {
        await this.demoRepository.createDemo(this.titleInput, this.descInput);
      }
      this.resetInputs();
      await this.fetchList();
    });
  }

  /**
   * 删除指定记录
   * @param {number} id - 记录主键
   * @returns {Promise<void>} Promise<void>
   */
  async delete(id: number): Promise<void> {
    if (!id) {
      return;
    }
    await this.runWithLoading(async (): Promise<void> => {
      await this.demoRepository.deleteDemo(id);
      if (this.editingId === id) {
        this.resetInputs();
      }
      await this.fetchList();
    });
  }

  /**
   * 刷新列表
   * @returns {Promise<void>} Promise<void>
   */
  async refreshList(): Promise<void> {
    await this.runWithLoading(async (): Promise<void> => {
      await this.fetchList();
    });
  }

  /**
   * 清空全部记录
   * @returns {Promise<void>} Promise<void>
   */
  async clearAll(): Promise<void> {
    await this.runWithLoading(async (): Promise<void> => {
      await this.demoRepository.clearAll();
      this.resetInputs();
      await this.fetchList();
    });
  }

  /**
   * 更新指定 ID 的记录
   * @param {number} id - 记录主键
   * @returns {Promise<void>} Promise<void>
   */
  private async updateById(id: number): Promise<void> {
    const entity: DemoEntity = new DemoEntity();
    entity.id = id;
    entity.title = this.titleInput.trim();
    entity.description = this.descInput.trim();
    await this.demoRepository.updateDemo(entity);
  }

  /**
   * 重置输入框内容
   * @returns {void} 无返回值
   */
  private resetInputs(): void {
    this.titleInput = "";
    this.descInput = "";
    this.editingId = 0;
  }

  /**
   * 获取列表数据
   * @returns {Promise<void>} Promise<void>
   */
  private async fetchList(): Promise<void> {
    this.items = await this.demoRepository.getAll();
  }

  /**
   * 执行带加载状态的任务
   * @param {() => Promise<void>} task - 待执行任务
   * @returns {Promise<void>} Promise<void>
   */
  private async runWithLoading(task: () => Promise<void>): Promise<void> {
    if (this.loading) {
      return;
    }
    this.loading = true;
    try {
      await task();
    } finally {
      this.loading = false;
    }
  }
}
