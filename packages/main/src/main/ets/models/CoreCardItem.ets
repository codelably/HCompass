/**
 * @file 核心模块卡片信息
 * @author Joker.X
 */
export interface CoreCardItem {
  /**
   * 标题
   */
  title: Resource;

  /**
   * 描述内容
   */
  description: Resource;

  /**
   * 点击事件
   */
  onClick: () => void;
}