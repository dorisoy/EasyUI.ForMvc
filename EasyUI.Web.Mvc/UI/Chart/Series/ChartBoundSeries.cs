




namespace EasyUI.Web.Mvc.UI
{
    using System;
    using System.Collections;
    using System.Linq.Expressions;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.Resources;

    /// <summary>
    /// Represents Chart series bound to data.
    /// </summary>
    /// <typeparam name="TModel">The Chart model type</typeparam>
    /// <typeparam name="TValue">The value type</typeparam>
    public abstract class ChartBoundSeries<TModel, TValue> : ChartSeriesBase<TModel>, IChartBoundSeries where TModel : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartBoundSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        /// <param name="expression">The expression.</param>
        protected ChartBoundSeries(Chart<TModel> chart, Expression<Func<TModel, TValue>> expression)
        : base(chart)
        {
            Guard.IsNotNull(expression, "expression");

            if (typeof(TModel).IsPlainType() && !expression.IsBindable())
            {
                throw new InvalidOperationException(TextResource.MemberExpressionRequired);
            }

            Expression = expression;
            Member = expression.MemberWithoutInstance();
            Value = expression.Compile();

            if (string.IsNullOrEmpty(Name))
            {
                Name = Member.AsTitle();
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartBoundSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        /// <param name="data">The data.</param>
        protected ChartBoundSeries(Chart<TModel> chart, IEnumerable data)
            : base(chart)
        {
            Guard.IsNotNull(data, "data");

            Data = data;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartBoundSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        protected ChartBoundSeries(Chart<TModel> chart)
            : base(chart)
        {

        }

        /// <summary>
        /// Gets a function which returns the value of the property to which the column is bound to.
        /// </summary>
        public Func<TModel, TValue> Value
        {
            get;
            private set;
        }

        /// <summary>
        /// The data used for binding.
        /// </summary>
        public IEnumerable Data
        {
            get;
            set;
        }

        /// <summary>
        /// The expression used to extract the value from the model
        /// </summary>
        public Expression<Func<TModel, TValue>> Expression
        {
            get;
            private set;
        }

        /// <summary>
        /// Gets the model data member name.
        /// </summary>
        /// <value>The model data member name.</value>
        public string Member
        {
            get;
            set;
        }

        /// <summary>
        /// Binds the series
        /// </summary>
        protected void BindChartData()
        {
            if (Chart.DataSource != null)
            {
                var dataList = new ArrayList();

                foreach (var dataPoint in Chart.DataSource)
                {
                    dataList.Add(Value(dataPoint));
                }

                Data = dataList;
            }
        }
    }
}
