/**
 * @file Demo 仓库定义，衔接业务层与本地数据库。
 * @description 如果需要与其他模块共享，请移到 shared/contracts 共享契约层
 * @author JunBin.Yang
 */

import { DemoEntity } from "../models/DemoEntity";

/**
 * 定义跨功能包共享的 DI 服务键
 * @description 不跨包共享时不需要 Key
 */
export const DEMO_REPOSITORY_KEY: string = "demoRepository";

export interface IDemoRepository {
  /**
   * 创建 Demo 记录
   * @param {string} title - 标题
   * @param {string} description - 描述
   * @returns {Promise<number>} 新建记录主键
   */
  createDemo(title: string, description: string): Promise<number>;

  /**
   * 更新 Demo 记录
   * @param {DemoEntity} entity - 待更新的实体
   * @returns {Promise<void>} Promise<void>
   */
  updateDemo(entity: DemoEntity): Promise<void>;

  /**
   * 删除指定 ID 的 Demo 记录
   * @param {number} id - 记录主键
   * @returns {Promise<void>} Promise<void>
   */
  deleteDemo(id: number): Promise<void>;

  /**
   * 清空全部 Demo 记录
   * @returns {Promise<number>} 受影响行数
   */
  clearAll(): Promise<number>;

  /**
   * 获取所有 Demo 记录，按更新时间倒序
   * @returns {Promise<DemoEntity[]>} Demo 列表
   */
  getAll(): Promise<DemoEntity[]>;

  /**
   * 根据主键查询单条 Demo 记录
   * @param {number} id - 记录主键
   * @returns {Promise<DemoEntity | undefined>} 匹配到的记录或 undefined
   */
  getById(id: number): Promise<DemoEntity | undefined>;
}