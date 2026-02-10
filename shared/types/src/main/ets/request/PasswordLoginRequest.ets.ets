/**
 * @file 密码登录请求模型
 * @author Joker.X
 */
export class PasswordLoginRequest {
  /**
   * 手机号
   */
  phone: string = "";
  /**
   * 密码
   */
  password: string = "";

  /**
   * 构造函数
   * @param {string} phone - 手机号
   * @param {string} password - 密码
   */
  constructor(phone: string = "", password: string = "") {
    this.phone = phone;
    this.password = password;
  }
}
