




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using System;
    using System.Collections;
    using System.Linq.Expressions;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.Resources;
    using EasyUI.Web.Mvc.UI;

    /// <summary>
    /// Configures the category axis for the <see cref="Chart{TModel}" />.
    /// </summary>
    /// <typeparam name="TModel">The type of the data item to which the chart is bound to</typeparam>
    public class ChartCategoryAxisBuilder<TModel> : ChartAxisBuilderBase<IChartCategoryAxis, ChartCategoryAxisBuilder<TModel>>
        where TModel : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartCategoryAxisBuilder{TModel}"/> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        public ChartCategoryAxisBuilder(Chart<TModel> chart)
            : base(chart.CategoryAxis)
        {
            Guard.IsNotNull(chart, "container");

            Container = chart;
        }

        /// <summary>
        /// The parent Chart
        /// </summary>
        public Chart<TModel> Container
        {
            get;
            private set;
        }

        /// <summary>
        /// Defines bound categories.
        /// </summary>
        /// <param name="expression">
        /// The expression used to extract the categories value from the chart model
        /// </param>
        public ChartCategoryAxisBuilder<TModel> Categories<TValue>(Expression<Func<TModel, TValue>> expression)
        {
            Guard.IsNotNull(expression, "expression");

            if (typeof(TModel).IsPlainType() && !expression.IsBindable())
            {
                throw new InvalidOperationException(TextResource.MemberExpressionRequired);
            }

            var value = expression.Compile();

            if (Container.DataSource != null)
            {
                var dataList = new ArrayList();

                foreach (var dataPoint in Container.DataSource)
                {
                    dataList.Add(value(dataPoint));
                }

                Container.CategoryAxis.Categories = dataList;
            }
            else
            {
                Container.CategoryAxis.Member = expression.MemberWithoutInstance();
            }

            return this;
        }

        /// <summary>
        /// Defines categories.
        /// </summary>
        /// <param name="categories">
        /// The list of categories
        /// </param>
        public ChartCategoryAxisBuilder<TModel> Categories(IEnumerable categories)
        {
            Guard.IsNotNull(categories, "categories");
            
            Container.CategoryAxis.Categories = categories;

            return this;
        }

        /// <summary>
        /// Defines categories.
        /// </summary>
        /// <param name="categories">
        /// The list of categories
        /// </param>
        public ChartCategoryAxisBuilder<TModel> Categories(params string[] categories)
        {
            Guard.IsNotNull(categories, "categories");

            Container.CategoryAxis.Categories = categories;

            return this;
        }

        /// <summary>
        /// Sets the axis orientation. The ValueAxis orientation should be set to match.
        /// </summary>
        /// <param name="orientation">The orientation. The default value is inferred from the series type.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Chart(Model)
        ///             .Name("Chart")
        ///             .CategoryAxis(c => c.Orientation(ChartAxisOrientation.Vertical))
        ///             .ValueAxis(v => v.Orientation(ChartAxisOrientation.Horizontal))
        ///             .Series(series => series.Line(s => s.Sales))
        /// %&gt;
        /// </code>
        /// </example>
        public ChartCategoryAxisBuilder<TModel> Orientation(ChartAxisOrientation orientation)
        {
            Container.CategoryAxis.Orientation = orientation;

            return this;
        }
    }
}
