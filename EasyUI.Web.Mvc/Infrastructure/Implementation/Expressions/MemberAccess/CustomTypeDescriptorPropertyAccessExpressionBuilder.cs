




namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System;
    using System.ComponentModel;
    using System.Globalization;
    using System.Linq.Expressions;
    using System.Reflection;

    using Extensions;

    /// <summary>
    /// �Զ������������������ʱ��ʽ������
    /// </summary>
    internal class CustomTypeDescriptorPropertyAccessExpressionBuilder : MemberAccessExpressionBuilderBase
    {
        private static readonly MethodInfo PropertyMethod = typeof(CustomTypeDescriptorExtensions).GetMethod("Property");
        private readonly Type propertyType;

        /// <exception cref="ArgumentException"><paramref name="elementType"/> δʵ�ֽӿ� <see cref="ICustomTypeDescriptor"/>.</exception>
        public CustomTypeDescriptorPropertyAccessExpressionBuilder(Type elementType, Type memberType, string memberName)
            : base(elementType, memberName)
        {
            if (!elementType.IsCompatibleWith(typeof(ICustomTypeDescriptor)))
            {
                throw new ArgumentException(
                    string.Format(CultureInfo.CurrentCulture, "ElementType: {0} did not implement {1}", elementType, typeof(ICustomTypeDescriptor)),
                    "elementType");
            }

            this.propertyType = GetPropertyType(memberType);
        }

        private Type GetPropertyType(Type memberType)
        {
            var descriptorProviderPropertyType = this.GetPropertyTypeFromTypeDescriptorProvider();
            if (descriptorProviderPropertyType != null)
            {
                memberType = descriptorProviderPropertyType;
            }
             //������ֵ������Ϊnull����DBNull.Value��ֵ��֧��ֱ��ת��ΪNullable<> ����
            if (memberType.IsValueType && !memberType.IsNullableType())
            {
                return typeof(Nullable<>).MakeGenericType(memberType);
            }

            return memberType;
        }

        private Type GetPropertyTypeFromTypeDescriptorProvider()
        {
            var propertyDescriptor = TypeDescriptor.GetProperties(this.ItemType)[this.MemberName];
            if (propertyDescriptor != null)
            {
                return propertyDescriptor.PropertyType;
            }

            return null;
        }

        public Type PropertyType
        {
            get
            {
                return this.propertyType;
            }
        }

        public override Expression CreateMemberAccessExpression()
        {
            ConstantExpression propertyNameExpression = Expression.Constant(this.MemberName);

            MethodCallExpression propertyExpression =
                Expression.Call(
                    PropertyMethod.MakeGenericMethod(this.propertyType),
                    this.ParameterExpression,
                    propertyNameExpression);

            return propertyExpression;
        }
    }
}