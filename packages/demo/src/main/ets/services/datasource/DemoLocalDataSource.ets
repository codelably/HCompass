import { DemoEntity } from "../../models/DemoEntity";

/**
 * @file Demo 数据源接口，定义本地 CRUD 能力。
 * @author Joker.X
 */
export interface DemoLocalDataSource {
  /**
   * 新增一条 Demo 记录
   * @param {string} title - 标题
   * @param {string} [description] - 描述
   * @returns {Promise<number>} 新建记录主键
   */
  createItem(title: string, description?: string): Promise<number>;

  /**
   * 更新 Demo 记录
   * @param {DemoEntity} entity - 待更新实体
   * @returns {Promise<void>} Promise<void>
   */
  updateItem(entity: DemoEntity): Promise<void>;

  /**
   * 按主键删除 Demo 记录
   * @param {number} id - 记录主键
   * @returns {Promise<void>} Promise<void>
   */
  deleteById(id: number): Promise<void>;

  /**
   * 清空 Demo 表
   * @returns {Promise<number>} 受影响行数
   */
  clearAll(): Promise<number>;

  /**
   * 查询全部 Demo 记录，默认按更新时间倒序
   * @returns {Promise<DemoEntity[]>} Demo 列表
   */
  getAllItems(): Promise<DemoEntity[]>;

  /**
   * 根据主键查询单条记录
   * @param {number} id - 记录主键
   * @returns {Promise<DemoEntity | undefined>} 匹配到的 Demo 或 undefined
   */
  getItemById(id: number): Promise<DemoEntity | undefined>;
}
