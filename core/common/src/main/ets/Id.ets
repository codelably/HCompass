/**
 * ID模型
 * 用于处理只返回ID的接口响应
 * @author JunBin.Yang
 */
export class Id {
  /**
   * ID值
   */
  id: number;

  constructor(id: number = 0) {
    this.id = id;
  }
}
