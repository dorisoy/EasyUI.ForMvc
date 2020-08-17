﻿




namespace EasyUI.Web.Mvc.UI
{
    using System;
    using System.Collections;
    using System.Linq.Expressions;

    /// <summary>
    /// Represents chart line series
    /// </summary>
    /// <typeparam name="TModel">The Chart model type</typeparam>
    /// <typeparam name="TValue">The value type</typeparam>
    public class ChartLineSeries<TModel, TValue> : ChartBoundSeries<TModel, TValue>, IChartLineSeries where TModel : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartBarSeries{TModel, TValue}"/> class.
        /// </summary>
        /// <param name="chart">The parent chart</param>
        /// <param name="expression">The expression used to extract the series value from the chart model.</param>
        public ChartLineSeries(Chart<TModel> chart, Expression<Func<TModel, TValue>> expression)
            : base(chart, expression)
        {
            Initialize();
            BindChartData();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartLineSeries{TModel, TValue}"/> class.
        /// </summary>
        /// <param name="chart">The parent chart</param>
        /// <param name="data">The data to bind to.</param>
        public ChartLineSeries(Chart<TModel> chart, IEnumerable data)
            : base(chart, data)
        {
            Initialize();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartLineSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        public ChartLineSeries(Chart<TModel> chart)
            : base(chart)
        {
            Initialize();
        }

        /// <summary>
        /// A value indicating if the lines should be stacked.
        /// </summary>
        public bool Stacked
        {
            get;
            set;
        }

        /// <summary>
        /// Gets the line chart data labels configuration
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
        /// The line chart line width.
        /// </summary>
        public double Width
        {
            get;
            set;
        }

        /// <summary>
        /// The behavior for handling missing values in line series.
        /// </summary>
        public ChartLineMissingValues MissingValues
        {
            get;
            set;
        }

        /// <summary>
        /// The line chart line dashType.
        /// </summary>
        public ChartDashType DashType
        {
            get;
            set;
        }

        /// <summary>
        /// Creates a serializer for the series
        /// </summary>
        public override IChartSerializer CreateSerializer()
        {
            return new ChartLineSeriesSerializer(this);
        }

        private void Initialize()
        {
            Stacked = false;
            Width = ChartDefaults.LineSeries.Width;
            Labels = new ChartPointLabels();
            Markers = new ChartMarkers();
            MissingValues = ChartDefaults.LineSeries.MissingValues;
            DashType = ChartDefaults.LineSeries.DashType;
        }
    }
}