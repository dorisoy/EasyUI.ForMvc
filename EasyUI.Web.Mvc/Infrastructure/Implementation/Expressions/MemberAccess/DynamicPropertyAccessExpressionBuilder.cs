﻿




#if MVC3
namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using System.Runtime.CompilerServices;
    using Microsoft.CSharp.RuntimeBinder;

    /// <summary>
    /// 动态属性访问表达式生成器
    /// </summary>
    internal class DynamicPropertyAccessExpressionBuilder : MemberAccessExpressionBuilderBase
    {
        public DynamicPropertyAccessExpressionBuilder(Type itemType, string memberName)
            : base(itemType, memberName)
        {
        }

        public override Expression CreateMemberAccessExpression()
        {
            //if no property specified then return the item itself
            if (string.IsNullOrEmpty(MemberName))
            {
                return this.ParameterExpression;
            }

            Expression instance = ParameterExpression;
            foreach (var token in MemberAccessTokenizer.GetTokens(MemberName))
            {
                if (token is PropertyToken)
                {
                    var propertyName = ((PropertyToken)token).PropertyName;
                    instance = CreatePropertyAccessExpression(instance, propertyName);
                }
                else if (token is IndexerToken)
                {
                    instance = CreateIndexerAccessExpression(instance, (IndexerToken)token);
                }

            }
            return instance;
        }

        private Expression CreateIndexerAccessExpression(Expression instance, IndexerToken indexerToken)
        {
            CallSiteBinder binder = Binder.GetIndex(CSharpBinderFlags.None,
                                          typeof(DynamicPropertyAccessExpressionBuilder),
                                                    new[]
                                                        {
                                                            CSharpArgumentInfo.Create(CSharpArgumentInfoFlags.None, null),
                                                            CSharpArgumentInfo.Create(
                                                                CSharpArgumentInfoFlags.Constant |
                                                                CSharpArgumentInfoFlags.UseCompileTimeType, null)
                                                        });

            return Expression.Dynamic(binder, typeof(object), new[] { instance, indexerToken.Arguments.Select(Expression.Constant).First() });
        }

        private Expression CreatePropertyAccessExpression(Expression instance, string propertyName)
        {
            CallSiteBinder binder = Binder.GetMember(CSharpBinderFlags.None, propertyName,
                typeof(DynamicPropertyAccessExpressionBuilder), new[] { CSharpArgumentInfo.Create(CSharpArgumentInfoFlags.None, null) });

            return Expression.Dynamic(binder, typeof(object), new[] { instance });
        }
    }
}
#endif