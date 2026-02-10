import { DemoEntity } from "../models/DemoEntity";
import { DemoLocalDataSource } from "./datasource/DemoLocalDataSource";
import { DemoLocalDataSourceImpl } from "./datasource/DemoLocalDataSourceImpl";
import { IDemoRepository } from "./IDemoRepository";

/**
 * @file Demo 仓库，衔接业务层与本地数据库。
 * @author Joker.X
 */
export class DemoRepositoryImpl implements IDemoRepository {
  /**
   * Demo 本地数据源
   */
  private demoLocalDataSource: DemoLocalDataSource;

  /**
   * 构造函数，支持注入自定义数据源（便于测试）
   * @param {DemoLocalDataSource} [localDataSource] - 可选的本地数据源
   */
  constructor(localDataSource?: DemoLocalDataSource) {
    this.demoLocalDataSource = localDataSource ?? new DemoLocalDataSourceImpl();
  }

  /**
   * 创建 Demo 记录
   * @param {string} title - 标题
   * @param {string} description - 描述
   * @returns {Promise<number>} 新建记录主键
   */
  async createDemo(title: string, description: string = ""): Promise<number> {
    return this.demoLocalDataSource.createItem(title, description);
  }

  /**
   * 更新 Demo 记录
   * @param {DemoEntity} entity - 待更新的实体
   * @returns {Promise<void>} Promise<void>
   */
  async updateDemo(entity: DemoEntity): Promise<void> {
    return this.demoLocalDataSource.updateItem(entity);
  }

  /**
   * 删除指定 ID 的 Demo 记录
   * @param {number} id - 记录主键
   * @returns {Promise<void>} Promise<void>
   */
  async deleteDemo(id: number): Promise<void> {
    return this.demoLocalDataSource.deleteById(id);
  }

  /**
   * 清空全部 Demo 记录
   * @returns {Promise<number>} 受影响行数
   */
  async clearAll(): Promise<number> {
    return this.demoLocalDataSource.clearAll();
  }

  /**
   * 获取所有 Demo 记录，按更新时间倒序
   * @returns {Promise<DemoEntity[]>} Demo 列表
   */
  async getAll(): Promise<DemoEntity[]> {
    return this.demoLocalDataSource.getAllItems();
  }

  /**
   * 根据主键查询单条 Demo 记录
   * @param {number} id - 记录主键
   * @returns {Promise<DemoEntity | undefined>} 匹配到的记录或 undefined
   */
  async getById(id: number): Promise<DemoEntity | undefined> {
    return this.demoLocalDataSource.getItemById(id);
  }
}
