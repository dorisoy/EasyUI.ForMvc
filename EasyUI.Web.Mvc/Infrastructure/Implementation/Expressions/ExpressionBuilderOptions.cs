




namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    /// <summary>
    /// 用于创建表达式的配置选项
    /// </summary>
    internal class ExpressionBuilderOptions
    {
        /// <summary>
        /// 允许访问为空成员
        /// </summary>
        /// <value>
        /// 	<c>true</c> if member access should be lifted to null; otherwise, <c>false</c>.
        /// </value>
        public bool LiftMemberAccessToNull { get; set; }

        public ExpressionBuilderOptions()
        {
            this.LiftMemberAccessToNull = true;
        }

        public void CopyFrom(ExpressionBuilderOptions other)
        {
            this.LiftMemberAccessToNull = other.LiftMemberAccessToNull;
        }
    }
}
