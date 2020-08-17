




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    using System.Linq.Expressions;
    using EasyUI.Web.Mvc.Infrastructure.Implementation.Expressions;
    /// <summary>
	/// The class enables implementation of custom filtering logic.
	/// </summary>
    public abstract class FilterDescription : FilterDescriptorBase
	{
		/// <summary>
		/// The method checks whether the passed parameter satisfies filter criteria. 
		/// </summary>
		public abstract bool SatisfiesFilter(object dataItem);

        /// <summary>
        /// If false <see cref="SatisfiesFilter"/> will not execute.
        /// </summary>
        public virtual bool IsActive
        {
            get
            {
                return true;
            }
        }

	    /// <summary>
	    /// Creates a predicate filter expression that calls <see cref="SatisfiesFilter"/>.
	    /// </summary>
	    /// <param name="parameterExpression">The parameter expression, which parameter 
	    /// will be passed to <see cref="SatisfiesFilter"/> method.</param>
	    protected override Expression CreateFilterExpression(ParameterExpression parameterExpression)
        {
            var expressionBuilder = new FilterDescriptionExpressionBuilder(parameterExpression, this);

            return expressionBuilder.CreateBodyExpression();
        }

	    
	}
}
