import { getORM } from "@core/database";
import { DemoEntity } from "../../models/DemoEntity";
import { DemoLocalDataSource } from "./DemoLocalDataSource";

/**
 * @file Demo 数据源实现，基于 IBest-ORM 封装 CRUD。
 * @author Joker.X
 */
export class DemoLocalDataSourceImpl implements DemoLocalDataSource {
  /**
   * 迁移标记，避免重复建表
   */
  private static migrated: boolean = false;
  /**
   * ORM 实例
   */
  private orm = getORM();

  constructor() {
    this.ensureMigrated();
  }

  /**
   * 确保 Demo 表完成迁移
   * @returns {void} 无返回
   */
  private ensureMigrated(): void {
    if (!DemoLocalDataSourceImpl.migrated) {
      this.orm.migrate(DemoEntity);
      DemoLocalDataSourceImpl.migrated = true;
    }
  }

  /**
   * 新增一条 Demo 记录
   * @param {string} title - 标题
   * @param {string} description - 描述
   * @returns {Promise<number>} 新建记录主键
   */
  async createItem(title: string, description: string = ""): Promise<number> {
    const entity: DemoEntity = new DemoEntity();
    entity.title = title;
    entity.description = description;
    return this.orm.insert(entity);
  }

  /**
   * 更新 Demo 记录
   * @param {DemoEntity} entity - 待更新实体
   * @returns {Promise<void>} Promise<void>
   */
  async updateItem(entity: DemoEntity): Promise<void> {
    this.orm.save(entity);
  }

  /**
   * 按主键删除 Demo 记录
   * @param {number} id - 记录主键
   * @returns {Promise<void>} Promise<void>
   */
  async deleteById(id: number): Promise<void> {
    this.orm.deleteById(DemoEntity, id);
  }

  /**
   * 清空 Demo 表
   * @returns {Promise<number>} 受影响行数
   */
  async clearAll(): Promise<number> {
    return this.orm.query(DemoEntity).delete();
  }

  /**
   * 查询全部 Demo 记录并按更新时间倒序
   * @returns {Promise<DemoEntity[]>} Demo 列表
   */
  async getAllItems(): Promise<DemoEntity[]> {
    const list: DemoEntity[] = this.orm.query(DemoEntity).find();
    // 以更新时间/创建时间倒序排列，便于展示最新数据
    return list.sort((left: DemoEntity, right: DemoEntity) => {
      const leftTime: number = new Date(left.updatedAt ?? left.createdAt ?? "").getTime() || 0;
      const rightTime: number = new Date(right.updatedAt ?? right.createdAt ?? "").getTime() || 0;
      return rightTime - leftTime;
    });
  }

  /**
   * 根据主键查询单条记录
   * @param {number} id - 记录主键
   * @returns {Promise<DemoEntity | undefined>} 匹配到的 Demo 或 undefined
   */
  async getItemById(id: number): Promise<DemoEntity | undefined> {
    const result: DemoEntity[] = this.orm.query(DemoEntity).where("id", id).find();
    return result[0];
  }
}
