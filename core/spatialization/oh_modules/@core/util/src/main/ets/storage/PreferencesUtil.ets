import preferences from "@ohos.data.preferences";
import common from "@ohos.app.ability.common";
import { Unknown } from "@core/common";

/**
 * @file Preferences 工具类，封装本地轻量级存储（@ohos.data.preferences）。
 * @author Joker.X
 */
export class PreferencesUtil {
  private prefsName: string;
  private context: common.Context;
  private prefsInstance?: preferences.Preferences;

  /**
   * 构造函数，保存上下文与文件名
   * @param {common.Context} context UIAbility 上下文
   * @param {string} prefsName 存储文件名（不含后缀）
   */
  constructor(context: common.Context, prefsName: string) {
    this.context = context;
    this.prefsName = prefsName;
  }

  /**
   * 获取 Preferences 实例（懒加载并复用）
   * @returns {Promise<preferences.Preferences>} Preferences 实例
   */
  private async getPrefs(): Promise<preferences.Preferences> {
    try {
      if (!this.prefsInstance) {
        this.prefsInstance = await preferences.getPreferences(this.context, this.prefsName);
      }
      return this.prefsInstance;
    } catch (error) {
      throw this.wrapError(error, "获取 Preferences 实例失败");
    }
  }

  /**
   * 写入键值并立即 flush 持久化
   * @param {string} key 键
   * @param {preferences.ValueType} value 值（支持 string/number/boolean）
   * @returns {Promise<void>} Promise<void>
   */
  async set(key: string, value: preferences.ValueType): Promise<void> {
    try {
      const prefs: preferences.Preferences = await this.getPrefs();
      await prefs.put(key, value);
      await prefs.flush();
    } catch (error) {
      throw this.wrapError(error, `写入键 ${key} 失败`);
    }
  }

  /**
   * 读取键值，若不存在返回默认值
   * @param {string} key 键
   * @param {preferences.ValueType} defaultValue 默认值
   * @returns {Promise<preferences.ValueType>} 读取到的值
   */
  async get(key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType> {
    try {
      const prefs: preferences.Preferences = await this.getPrefs();
      return prefs.get(key, defaultValue);
    } catch (error) {
      throw this.wrapError(error, `读取键 ${key} 失败`);
    }
  }

  /**
   * 判断键是否存在
   * @param {string} key 键
   * @returns {Promise<boolean>} 是否存在
   */
  async has(key: string): Promise<boolean> {
    try {
      const prefs: preferences.Preferences = await this.getPrefs();
      return prefs.has(key);
    } catch (error) {
      throw this.wrapError(error, `判断键 ${key} 是否存在失败`);
    }
  }

  /**
   * 删除指定键并 flush
   * @param {string} key 键
   * @returns {Promise<void>} Promise<void>
   */
  async remove(key: string): Promise<void> {
    try {
      const prefs: preferences.Preferences = await this.getPrefs();
      await prefs.delete(key);
      await prefs.flush();
    } catch (error) {
      throw this.wrapError(error, `删除键 ${key} 失败`);
    }
  }

  /**
   * 清空所有键值并 flush
   * @returns {Promise<void>} Promise<void>
   */
  async clear(): Promise<void> {
    try {
      const prefs: preferences.Preferences = await this.getPrefs();
      await prefs.clear();
      await prefs.flush();
    } catch (error) {
      throw this.wrapError(error, "清空偏好数据失败");
    }
  }

  /**
   * 统一封装业务异常，附加上下文提示
   * @param {unknown} error 捕获的异常
   * @param {string} message 补充说明
   * @returns {Error} 包装后的异常
   */
  private wrapError(error: Unknown, message: string): Error {
    if (error instanceof Error) {
      error.message = `${message}：${error.message}`;
      return error;
    }
    return new Error(message);
  }
}
