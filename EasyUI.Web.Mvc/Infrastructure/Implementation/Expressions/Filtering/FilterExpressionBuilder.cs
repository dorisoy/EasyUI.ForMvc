




namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System;
    using System.Linq.Expressions;

    /// <summary>
    /// ��ʾһ�����������ʽ�������������
    /// </summary>
    internal abstract class FilterExpressionBuilder : ExpressionBuilderBase
    {
        protected FilterExpressionBuilder(ParameterExpression parameterExpression) :
            base(parameterExpression.Type)
        {
            this.ParameterExpression = parameterExpression;
        }

        /// <summary>
        /// �������ʽ����
        /// </summary>
        /// <returns></returns>
        public abstract Expression CreateBodyExpression();

        
        // <exception cref="ArgumentException"><c>ArgumentException</c>.</exception>
        /// <summary>
        /// �������������ʽ
        /// </summary>
        /// <returns></returns>
        public LambdaExpression CreateFilterExpression()
        {
            Expression bodyExpression = this.CreateBodyExpression();
            return Expression.Lambda(bodyExpression, this.ParameterExpression);
        }
    }
}