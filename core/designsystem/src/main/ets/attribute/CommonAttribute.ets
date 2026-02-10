/**
 * @file 通用属性扩展
 * @author Joker.X
 */

/**
 * 快速设置宽高相同的 size
 * @param {Length} value - 宽高尺寸
 * @returns {AttributeModifier<CommonAttribute>} 通用属性修饰器
 * @example
* Column() { Text("Hi"); }.attributeModifier(size(24));
 */
export function size(value: Length): AttributeModifier<CommonAttribute> {
  return {
    applyNormalAttribute: (instance: CommonAttribute): void => {
      instance.size({ width: value, height: value });
    }
  };
}
