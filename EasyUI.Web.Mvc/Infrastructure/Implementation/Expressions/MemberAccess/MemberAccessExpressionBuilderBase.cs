




namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System;
    using System.Linq.Expressions;

    /// <summary>
    /// 成员访问表达式生成器基类
    /// </summary>
    internal abstract class MemberAccessExpressionBuilderBase : ExpressionBuilderBase
    {
        private readonly string memberName;

        protected MemberAccessExpressionBuilderBase(Type itemType, string memberName) : base(itemType)
        {
            this.memberName = memberName;
        }

        public string MemberName
        {
            get
            {
                return this.memberName;
            }
        }

        public abstract Expression CreateMemberAccessExpression();

        internal LambdaExpression CreateLambdaExpression()
        {
            Expression memberExpression = this.CreateMemberAccessExpression();
            return Expression.Lambda(memberExpression, this.ParameterExpression);
        }
    }
}