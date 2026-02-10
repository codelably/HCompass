/**
 * @file 用户信息模型
 * @author Joker.X
 */
@ObservedV2
export class User {
  /**
   * ID
   */
  @Trace
  id: number = 0;
  /**
   * 头像
   */
  @Trace
  avatarUrl: string = "";
  /**
   * 昵称
   */
  @Trace
  nickName: string = "";
  /**
   * 手机号
   */
  @Trace
  phone: string = "";
  /**
   * 性别 0-未知 1-男 2-女
   */
  @Trace
  gender: number = 0;
  /**
   * 状态 0-禁用 1-正常 2-已注销
   */
  status: number = 1;
  /**
   * 登录方式 0-小程序 1-公众号 2-H5
   */
  loginType: string = "0";
  /**
   * 密码
   */
  password: string = "";
  /**
   * 创建时间
   */
  createTime: string = "";
  /**
   * 更新时间
   */
  updateTime: string = "";

  /**
   * 构造函数，初始化用户对象
   * @param {Partial<User>} data - 原始用户数据
   */
  constructor(data?: Partial<User>) {
    if (data) {
      this.id = data.id ?? 0;
      this.avatarUrl = data.avatarUrl ?? "";
      this.nickName = data.nickName ?? "";
      this.phone = data.phone ?? "";
      this.gender = data.gender ?? 0;
      this.status = data.status ?? 1;
      this.loginType = data.loginType ?? "0";
      this.password = data.password ?? "";
      this.createTime = data.createTime ?? "";
      this.updateTime = data.updateTime ?? "";
    }
  }

  /**
   * 从接口响应构建安全的用户对象
   * @param {Partial<User>} data - 新的用户数据
   * @returns {User} 用户对象
   */
  static fromResponse(data: Partial<User>): User {
    return new User(data);
  }
}
