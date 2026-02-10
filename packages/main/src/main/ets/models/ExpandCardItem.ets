/**
 * @file 扩展模块卡片信息
 * @author Joker.X
 */
export interface ExpandCardItem {
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
