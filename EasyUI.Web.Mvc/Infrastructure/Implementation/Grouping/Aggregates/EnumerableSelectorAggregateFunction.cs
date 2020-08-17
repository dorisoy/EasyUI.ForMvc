




namespace EasyUI.Web.Mvc
{
    using System.Linq;
    using System.Linq.Expressions;
    using EasyUI.Web.Mvc.Infrastructure.Implementation;
    using EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions;

    /// <summary>
    /// Represents an <see cref="AggregateFunction"/> that uses aggregate extension 
    /// methods provided in <see cref="Enumerable"/> using <see cref="SourceField"/>
    /// as a member selector.
    /// </summary>
    public abstract class EnumerableSelectorAggregateFunction : EnumerableAggregateFunctionBase
    {
        /// <summary>
        /// Creates the aggregate expression using <see cref="EnumerableSelectorAggregateFunctionExpressionBuilder"/>.
        /// </summary>
        /// <param name="enumerableExpression">The grouping expression.</param>
        /// <param name="liftMemberAccessToNull"></param>
        /// <returns></returns>
        public override Expression CreateAggregateExpression(Expression enumerableExpression, bool liftMemberAccessToNull)
        {
            var builder = new EnumerableSelectorAggregateFunctionExpressionBuilder(enumerableExpression, this);
            builder.Options.LiftMemberAccessToNull = liftMemberAccessToNull;
            return builder.CreateAggregateExpression();
        }
    }
}