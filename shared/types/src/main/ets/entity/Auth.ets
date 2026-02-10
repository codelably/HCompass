/**
 * @file 认证令牌模型
 * @author Joker.X
 */
@ObservedV2
export class Auth {
  /**
   * token
   */
  @Trace
  token: string = "";
  /**
   * 刷新 token
   */
  refreshToken: string = "";
  /**
   * token 过期时间(秒)
   */
  expire: number = 0;
  /**
   * 刷新令牌过期时间
   */
  refreshExpire: number = 0;
  /**
   * 令牌创建时间(不来自服务端)
   */
  createdAt: number = Date.now();

  /**
   * 构造函数，支持对接口返回的数据做空值兜底
   * @param {Partial<Auth>} data - 原始认证数据
   */
  constructor(data?: Partial<Auth>) {
    if (data) {
      this.token = data.token ?? "";
      this.refreshToken = data.refreshToken ?? "";
      this.expire = data.expire ?? 0;
      this.refreshExpire = data.refreshExpire ?? 0;
      this.createdAt = data.createdAt ?? Date.now();
    }
  }

  /**
   * 从接口响应构建安全的认证对象
   * @param {Partial<Auth>} data - 接口返回的认证数据
   * @returns {Auth} 已兜底的认证对象
   */
  static fromResponse(data: Partial<Auth>): Auth {
    return new Auth(data);
  }

  /**
   * 检查访问令牌是否过期
   * @returns {boolean} 是否过期
   */
  isExpired(): boolean {
    const currentTime: number = Date.now();
    const expirationTime: number = this.createdAt + this.expire * 1000;
    return currentTime >= expirationTime;
  }

  /**
   * 检查刷新令牌是否过期
   * @returns {boolean} 是否过期
   */
  isRefreshTokenExpired(): boolean {
    const currentTime: number = Date.now();
    const expirationTime: number = this.createdAt + this.refreshExpire * 1000;
    return currentTime >= expirationTime;
  }

  /**
   * 检查令牌是否需要刷新（过期前15分钟）
   * @returns {boolean} 是否需要刷新
   */
  shouldRefresh(): boolean {
    const currentTime: number = Date.now();
    const refreshTime: number = this.createdAt + this.expire * 1000 - 15 * 60 * 1000;
    return currentTime >= refreshTime && !this.isRefreshTokenExpired();
  }
}
