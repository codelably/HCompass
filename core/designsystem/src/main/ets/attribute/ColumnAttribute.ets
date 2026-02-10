/**
 * @file Column 对齐属性扩展
 * @author Joker.X
 */

/**
 * 获取纵向居中 + 水平居中的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("Hi"); }.attributeModifier(columnCenter());
 */
export function columnCenter(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.Center);
      instance.alignItems(HorizontalAlign.Center);
    }
  };
}

/**
 * 获取纵向起始 + 水平起始的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("Hi"); }.attributeModifier(columnStart());
 */
export function columnStart(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.Start);
      instance.alignItems(HorizontalAlign.Start);
    }
  };
}

/**
 * 获取纵向末尾 + 水平末尾的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("Hi"); }.attributeModifier(columnEnd());
 */
export function columnEnd(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.End);
      instance.alignItems(HorizontalAlign.End);
    }
  };
}

/**
 * 获取纵向两端分布 + 水平居中的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("A"); Text("B"); }.attributeModifier(columnSpaceBetween());
 */
export function columnSpaceBetween(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.SpaceBetween);
      instance.alignItems(HorizontalAlign.Center);
    }
  };
}

/**
 * 获取纵向居中 + 水平起始的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("Hi"); }.attributeModifier(columnCenterStart());
 */
export function columnCenterStart(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.Center);
      instance.alignItems(HorizontalAlign.Start);
    }
  };
}

/**
 * 获取纵向居中 + 水平末尾的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("Hi"); }.attributeModifier(columnCenterEnd());
 */
export function columnCenterEnd(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.Center);
      instance.alignItems(HorizontalAlign.End);
    }
  };
}

/**
 * 获取纵向起始 + 水平居中的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("Hi"); }.attributeModifier(columnStartCenter());
 */
export function columnStartCenter(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.Start);
      instance.alignItems(HorizontalAlign.Center);
    }
  };
}

/**
 * 获取纵向末尾 + 水平居中的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("Hi"); }.attributeModifier(columnEndCenter());
 */
export function columnEndCenter(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.End);
      instance.alignItems(HorizontalAlign.Center);
    }
  };
}

/**
 * 获取纵向两端分布 + 水平起始的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("A"); Text("B"); }.attributeModifier(columnSpaceBetweenStart());
 */
export function columnSpaceBetweenStart(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.SpaceBetween);
      instance.alignItems(HorizontalAlign.Start);
    }
  };
}

/**
 * 获取纵向两端分布 + 水平末尾的 Column 对齐修饰器
 * @returns {AttributeModifier<ColumnAttribute>} Column 对齐修饰器
 * @example
* Column() { Text("A"); Text("B"); }.attributeModifier(columnSpaceBetweenEnd());
 */
export function columnSpaceBetweenEnd(): AttributeModifier<ColumnAttribute> {
  return {
    applyNormalAttribute: (instance: ColumnAttribute): void => {
      instance.justifyContent(FlexAlign.SpaceBetween);
      instance.alignItems(HorizontalAlign.End);
    }
  };
}
