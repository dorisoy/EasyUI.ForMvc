




namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System;
    using System.Linq.Expressions;

    /// <summary>
    /// 表示一个过滤器表达式生成器抽象基类
    /// </summary>
    internal abstract class FilterExpressionBuilder : ExpressionBuilderBase
    {
        protected FilterExpressionBuilder(ParameterExpression parameterExpression) :
            base(parameterExpression.Type)
        {
            this.ParameterExpression = parameterExpression;
        }

        /// <summary>
        /// 创建表达式主体
        /// </summary>
        /// <returns></returns>
        public abstract Expression CreateBodyExpression();

        
        // <exception cref="ArgumentException"><c>ArgumentException</c>.</exception>
        /// <summary>
        /// 创建过滤器表达式
        /// </summary>
        /// <returns></returns>
        public LambdaExpression CreateFilterExpression()
        {
            Expression bodyExpression = this.CreateBodyExpression();
            return Expression.Lambda(bodyExpression, this.ParameterExpression);
        }
    }
}