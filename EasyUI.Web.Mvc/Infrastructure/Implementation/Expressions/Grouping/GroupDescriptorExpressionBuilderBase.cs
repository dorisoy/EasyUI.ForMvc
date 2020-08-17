




namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System.ComponentModel;
    using System.Linq;
    using System.Linq.Expressions;

    using Extensions;
    
    internal abstract class GroupDescriptorExpressionBuilderBase : ExpressionBuilderBase
    {
        private IQueryable queryable;

        protected GroupDescriptorExpressionBuilderBase(IQueryable queryable) : base(queryable.ElementType)
        {
            this.queryable = queryable;
        }

        public virtual IQueryable Queryable
        {
            get
            {
                return this.queryable;
            }
            protected set
            {
                this.queryable = value;
            }
        }

        public IQueryable CreateQuery()
        {
            return
                queryable.
                    GroupBy(this.CreateGroupByExpression()).
                    OrderBy(this.CreateOrderByExpression(), SortDirection).
                    Select(this.CreateSelectExpression());

        }

        protected virtual ListSortDirection? SortDirection
        {
            get
            {
                return null;
            }
        }

        protected abstract LambdaExpression CreateGroupByExpression();
        protected abstract LambdaExpression CreateOrderByExpression();
        protected abstract LambdaExpression CreateSelectExpression();
    }
}