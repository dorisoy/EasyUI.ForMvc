namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System;
    using System.Linq.Expressions;


    /// <summary>
    /// ���ʽ�������������
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
        /// ��ȡ����������ѡ��
        /// </summary>
        public ExpressionBuilderOptions Options
        {
            get
            {
                return this.options;
            }
        }

        /// <summary>
        /// ��ʾ��ȡһ����Ŀ����
        /// </summary>
        protected internal Type ItemType
        {
            get
            {
                return this.itemType;
            }
        }

        /// <summary>
        /// ��ȡ�������ñ��ʽ����
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