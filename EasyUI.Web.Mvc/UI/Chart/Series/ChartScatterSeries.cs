




namespace EasyUI.Web.Mvc.UI
{
    using System;
    using System.Linq.Expressions;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.Resources;
    using System.Collections.Generic;
    using System.Collections;

    /// <summary>
    /// Represents chart scatter (XY) series
    /// </summary>
    /// <typeparam name="TModel">The Chart model type</typeparam>
    /// <typeparam name="TValue">The value type</typeparam>
    public class ChartScatterSeries<TModel, TValue> : ChartSeriesBase<TModel>, IChartScatterSeries where TModel : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartScatterSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        /// <param name="expressionXValue">The X expression.</param>
        /// <param name="expressionYValue">The Y expression.</param>
        public ChartScatterSeries(Chart<TModel> chart, Expression<Func<TModel, TValue>> xValueExpression, Expression<Func<TModel, TValue>> yValueExpression)
            : base(chart)
        {
            Guard.IsNotNull(xValueExpression, "xValueExpression");
            Guard.IsNotNull(yValueExpression, "yValueExpression");

            if (typeof(TModel).IsPlainType() && !(xValueExpression.IsBindable() || yValueExpression.IsBindable()))
            {
                throw new InvalidOperationException(TextResource.MemberExpressionRequired);
            }

            XValueExpression = xValueExpression;
            YValueExpression = yValueExpression;

            XMember = xValueExpression.MemberWithoutInstance();
            YMember = yValueExpression.MemberWithoutInstance();

            XValue = xValueExpression.Compile();
            YValue = yValueExpression.Compile();

            Initialize();
            BindChartData();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartScatterSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        /// <param name="data">The data.</param>
        public ChartScatterSeries(Chart<TModel> chart, IEnumerable data)
            : base(chart)
        {
            Guard.IsNotNull(data, "data");

            Data = data;
            Initialize();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartScatterSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        public ChartScatterSeries(Chart<TModel> chart)
            : base(chart)
        {
            Initialize();
        }

        /// <summary>
        /// The expression used to extract the X value from the model
        /// </summary>
        public Expression<Func<TModel, TValue>> XValueExpression
        {
            get;
            private set;
        }

        /// <summary>
        /// The expression used to extract the Y value from the model
        /// </summary>
        public Expression<Func<TModel, TValue>> YValueExpression
        {
            get;
            private set;
        }

        /// <summary>
        /// Gets the model X data member name.
        /// </summary>
        /// <value>The model X data member name.</value>
        public string XMember
        {
            get;
            set;
        }

        /// <summary>
        /// Gets the model Y data member name.
        /// </summary>
        /// <value>The model Y data member name.</value>
        public string YMember
        {
            get;
            set;
        }

        /// <summary>
        /// Gets a function which returns the value of the property to which the X value is bound to.
        /// </summary>
        public Func<TModel, TValue> XValue
        {
            get;
            private set;
        }

        /// <summary>
        /// Gets a function which returns the value of the property to which the Y value is bound to.
        /// </summary>
        public Func<TModel, TValue> YValue
        {
            get;
            private set;
        }

        /// <summary>
        /// Gets the scatter chart data labels configuration
        /// </summary>
        public ChartPointLabels Labels
        {
            get;
            set;
        }

        /// <summary>
        /// The line chart markers configuration.
        /// </summary>
        public ChartMarkers Markers
        {
            get;
            set;
        }

        /// <summary>
        /// The scatter chart data source.
        /// </summary>
        public IEnumerable Data
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
                var dataList = new List<TValue[]>();

                foreach (var dataPoint in Chart.DataSource)
                {
                    dataList.Add(
                        new TValue[] { XValue(dataPoint), YValue(dataPoint) }
                    );
                }

                Data = dataList;
            }
        }

        protected virtual void Initialize()
        {
            Labels = new ChartPointLabels();
            Markers = new ChartMarkers();
        }

        /// <summary>
        /// Creates a serializer for the series
        /// </summary>
        public override IChartSerializer CreateSerializer()
        {
            return new ChartScatterSeriesSerializer(this);
        }
    }
}