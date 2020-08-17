namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using System;


    /// <summary>
    /// 定义输入框接口
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public interface IInputBox<T> where T : struct
    {
        /// <summary>
        /// 要指定的Html 属性
        /// </summary>
        IDictionary<string, object> InputHtmlAttributes { get; }
        /// <summary>
        /// 表示控件值
        /// </summary>
        Nullable<T> Value { get; set; }
        /// <summary>
        /// 允许输入的最大值
        /// </summary>
        Nullable<T> MinValue { get; set; }
        /// <summary>
        /// 允许输入的最小值
        /// </summary>
        Nullable<T> MaxValue { get; set; }
        /// <summary>
        /// 数值型时的步增量
        /// </summary>
        T IncrementStep { get; set; }
    }
}
