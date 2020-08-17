
namespace EasyUI.Web.Mvc.UI
{
    using System;
    using System.Collections;
    using System.Collections.Generic;

    /// <summary>
    /// 定义创建客户端对象的基本构建块.
    /// </summary>
    public interface IClientSideObjectWriter
    {
        /// <summary>
        /// 开始写入实例.
        /// </summary>
        /// <returns></returns>
        IClientSideObjectWriter Start();

        /// <summary>
        /// 追加特定键值对到实例尾部.
        /// </summary>
        /// <param name="keyValuePair">The key value pair.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string keyValuePair);

        /// <summary>
        /// 追加特定名称和字符串值到实例尾部.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, string value);

        /// <summary>
        /// 追加特定名称和空字符值到实例尾部.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter AppendNullableString(string name, string value);
       
        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, int value);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <param name="defaultValue">The default value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, int value, int defaultValue);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, int? value);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, double value);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, double? value);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, decimal value);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, decimal? value);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">if set to <c>true</c> [value].</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, bool value);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">if set to <c>true</c> [value].</param>
        /// <param name="defaultValue">if set to <c>true</c> [default value].</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, bool value, bool defaultValue);

        /// <summary>
        /// Appends the specified name and only the date of the passed <seealso cref="DateTime"/>.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter AppendDateOnly(string name, DateTime date);

        /// <summary>
        /// Appends the specified name and only the date of the passed <seealso cref="Nullable<DateTime>"/>.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter AppendDateOnly(string name, DateTime? date);

        /// <summary>
        /// Appends the specified name and only the dates of the passed <seealso cref="IEnumerable<DateTime>"/>.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter AppendDatesOnly(string name, IEnumerable<DateTime> dates);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, DateTime value);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, DateTime? value);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="action">The action.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, Action action);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="action">The action.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, Func<object, object> func);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="values">The HtmlTemplate.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append(string name, HtmlTemplate htmlTemplate);

        IClientSideObjectWriter AppendCollection(string name, IEnumerable value);

        /// <summary>
        /// Appends the object.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        IClientSideObjectWriter AppendObject(string name, object value);

        /// <summary>
        /// Appends the specified name and Action or String specified in the ClientEvent object.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="event">Client event of the component.</param>
        /// <returns></returns>
        IClientSideObjectWriter AppendClientEvent(string name, ClientEvent clientEvent);

        /// <summary>
        /// Appends the specified name and value to the end of this instance.
        /// </summary>
        /// <typeparam name="TEnum">The type of the enum.</typeparam>
        /// <param name="name">The name.</param>
        /// <param name="value">The value.</param>
        /// <param name="defaultValue">The default value.</param>
        /// <returns></returns>
        IClientSideObjectWriter Append<TEnum>(string name, TEnum value, TEnum defaultValue) where TEnum : IComparable, IFormattable;

        /// <summary>
        /// 压缩实例.
        /// </summary>
        void Complete();
    }
}