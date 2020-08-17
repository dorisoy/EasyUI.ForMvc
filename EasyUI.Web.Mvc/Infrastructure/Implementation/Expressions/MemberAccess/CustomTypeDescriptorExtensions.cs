




namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System;
    using System.ComponentModel;
    using System.Globalization;

    /// <summary>
    ///  自定义类型属性描述信息扩展方法
    /// </summary>
    internal static class CustomTypeDescriptorExtensions
    {
        /// <exception cref="ArgumentException"><c>ArgumentException</c>.</exception>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1004:GenericMethodsShouldProvideTypeParameter")]
        public static T Property<T>(this ICustomTypeDescriptor typeDescriptor, string propertyName)
        {
            var propertyDescriptor = TypeDescriptor.GetProperties(typeDescriptor)[propertyName];

            if ( propertyDescriptor == null )
            {
                string message = string.Format(
                    CultureInfo.CurrentCulture, "Property with specified name: {0} cannot be found on type: {1}",
                    propertyName, typeDescriptor.GetType());

                throw new ArgumentException(message, "propertyName");
            }

            return UnboxT<T>.Unbox(propertyDescriptor.GetValue(typeDescriptor));
        }
    }
}