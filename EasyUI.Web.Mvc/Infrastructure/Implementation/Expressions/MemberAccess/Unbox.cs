




namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System;
    using System.Globalization;
    using System.Reflection;

    /// <summary>
    /// 表示一个拆箱转换操作类
    /// </summary>
    /// <typeparam name="T"></typeparam>
    internal static class UnboxT<T>
    {
        internal static readonly Converter<object, T> Unbox = Create(typeof(T));


        /// <summary>
        /// 将值类型转换为引用类型委托方法
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        private static Converter<object, T> Create(Type type)
        {
            //如果不是值类型
            if (!type.IsValueType)
            {
                return ReferenceField;
            }
            if ((type.IsGenericType && !type.IsGenericTypeDefinition) && (typeof(Nullable<>) == type.GetGenericTypeDefinition()))
            {
                MethodInfo nullableFieldMethod = typeof(UnboxT<T>).GetMethod("NullableField", BindingFlags.NonPublic | BindingFlags.Static);
                MethodInfo genericMethod = nullableFieldMethod.MakeGenericMethod(new[] { type.GetGenericArguments()[0] });
                
                return (Converter<object, T>) Delegate.CreateDelegate(typeof(Converter<object, T>), genericMethod);
            }
            return ValueField;
        }

        private static TElem? NullableField<TElem>(object value) where TElem : struct
        {
            if (DBNull.Value == value)
            {
                return null;
            }
            return (TElem?)value;
        }

        private static T ReferenceField(object value)
        {
            if (DBNull.Value != value)
            {
                return (T) value;
            }
            return default(T);
        }

        /// <exception cref="InvalidCastException"><c>InvalidCastException</c>.</exception>
        private static T ValueField(object value)
        {
            if (DBNull.Value == value)
            {
                //因无效类型转换或显式转换引发的异常
                throw new InvalidCastException(
                    string.Format(CultureInfo.CurrentCulture, "Type: {0} cannot be casted to Nullable type", typeof(T)));
            }
            return (T) value;
        }
    }
}