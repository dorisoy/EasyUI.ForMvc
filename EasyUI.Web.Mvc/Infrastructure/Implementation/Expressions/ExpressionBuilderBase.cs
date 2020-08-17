namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System;
    using System.Linq.Expressions;


    /// <summary>
    /// 表达式生成器抽象基类
    /// </summary>
    internal abstract class ExpressionBuilderBase
    {
        private readonly ExpressionBuilderOptions options;
        private readonly Type itemType;
        private ParameterExpression parameterExpression;

        protected ExpressionBuilderBase(Type itemType)
        {
            this.itemType = itemType;
            this.options = new ExpressionBuilderOptions();
        }

        /// <summary>
        /// 获取生成器配置选项
        /// </summary>
        public ExpressionBuilderOptions Options
        {
            get
            {
                return this.options;
            }
        }

        /// <summary>
        /// 表示获取一个项目类型
        /// </summary>
        protected internal Type ItemType
        {
            get
            {
                return this.itemType;
            }
        }

        /// <summary>
        /// 获取或者设置表达式参数
        /// </summary>
        protected internal ParameterExpression ParameterExpression
        {
            get
            {
                if (this.parameterExpression == null)
                {
                    this.parameterExpression = Expression.Parameter(this.ItemType, "item");
                }

                return this.parameterExpression;
            }
            set
            {
                this.parameterExpression = value;
            }
        }
    }
}