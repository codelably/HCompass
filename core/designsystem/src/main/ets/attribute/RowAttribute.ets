/**
 * @file Row 对齐属性扩展
 * @author Joker.X
 */

/**
 * 获取横向居中 + 垂直居中的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("Hi"); }.attributeModifier(rowCenter());
 */
export function rowCenter(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.Center);
      instance.alignItems(VerticalAlign.Center);
    }
  };
}

/**
 * 获取横向起始 + 垂直居中的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("Hi"); }.attributeModifier(rowStartCenter());
 */
export function rowStartCenter(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.Start);
      instance.alignItems(VerticalAlign.Center);
    }
  };
}

/**
 * 获取横向末尾 + 垂直居中的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("Hi"); }.attributeModifier(rowEndCenter());
 */
export function rowEndCenter(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.End);
      instance.alignItems(VerticalAlign.Center);
    }
  };
}

/**
 * 获取横向两端分布 + 垂直居中的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("A"); Text("B"); }.attributeModifier(rowSpaceBetweenCenter());
 */
export function rowSpaceBetweenCenter(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.SpaceBetween);
      instance.alignItems(VerticalAlign.Center);
    }
  };
}

/**
 * 获取横向居中 + 垂直顶部的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("Hi"); }.attributeModifier(rowCenterTop());
 */
export function rowCenterTop(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.Center);
      instance.alignItems(VerticalAlign.Top);
    }
  };
}

/**
 * 获取横向居中 + 垂直底部的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("Hi"); }.attributeModifier(rowCenterBottom());
 */
export function rowCenterBottom(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.Center);
      instance.alignItems(VerticalAlign.Bottom);
    }
  };
}

/**
 * 获取横向起始 + 垂直顶部的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("Hi"); }.attributeModifier(rowStartTop());
 */
export function rowStartTop(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.Start);
      instance.alignItems(VerticalAlign.Top);
    }
  };
}

/**
 * 获取横向起始 + 垂直底部的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("Hi"); }.attributeModifier(rowStartBottom());
 */
export function rowStartBottom(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.Start);
      instance.alignItems(VerticalAlign.Bottom);
    }
  };
}

/**
 * 获取横向末尾 + 垂直顶部的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("Hi"); }.attributeModifier(rowEndTop());
 */
export function rowEndTop(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.End);
      instance.alignItems(VerticalAlign.Top);
    }
  };
}

/**
 * 获取横向末尾 + 垂直底部的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("Hi"); }.attributeModifier(rowEndBottom());
 */
export function rowEndBottom(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.End);
      instance.alignItems(VerticalAlign.Bottom);
    }
  };
}

/**
 * 获取横向两端分布 + 垂直顶部的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("A"); Text("B"); }.attributeModifier(rowSpaceBetweenTop());
 */
export function rowSpaceBetweenTop(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.SpaceBetween);
      instance.alignItems(VerticalAlign.Top);
    }
  };
}

/**
 * 获取横向两端分布 + 垂直底部的 Row 对齐修饰器
 * @returns {AttributeModifier<RowAttribute>} Row 对齐修饰器
 * @example
* Row() { Text("A"); Text("B"); }.attributeModifier(rowSpaceBetweenBottom());
 */
export function rowSpaceBetweenBottom(): AttributeModifier<RowAttribute> {
  return {
    applyNormalAttribute: (instance: RowAttribute): void => {
      instance.justifyContent(FlexAlign.SpaceBetween);
      instance.alignItems(VerticalAlign.Bottom);
    }
  };
}
