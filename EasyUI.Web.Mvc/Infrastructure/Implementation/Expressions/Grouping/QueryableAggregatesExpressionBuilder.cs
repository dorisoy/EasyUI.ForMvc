




namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Linq.Expressions;
    using EasyUI.Web.Mvc.Extensions;

    internal class QueryableAggregatesExpressionBuilder : GroupDescriptorExpressionBuilder
    {
        public QueryableAggregatesExpressionBuilder(IQueryable queryable, IEnumerable<AggregateFunction> aggregateFunctions)
            : base(queryable, CreateDescriptor(aggregateFunctions))
        {
        }

        private static GroupDescriptor CreateDescriptor(IEnumerable<AggregateFunction> aggregateFunctions)
        {
            var groupDescriptor = new GroupDescriptor();
            groupDescriptor.AggregateFunctions.AddRange(aggregateFunctions);

            return groupDescriptor;
        }

        protected override LambdaExpression CreateGroupByExpression()
        {
            return Expression.Lambda(Expression.Constant(1), this.ParameterExpression);
        }
    }
}