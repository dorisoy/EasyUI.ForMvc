﻿




namespace EasyUI.Web.Mvc.UI
{
    using System;
    using System.Linq.Expressions;
    using System.Collections;

    /// <summary>
    /// Represents chart scatter line series
    /// </summary>
    /// <typeparam name="TModel">The Chart model type</typeparam>
    /// <typeparam name="TValue">The value type</typeparam>
    public class ChartScatterLineSeries<TModel, TValue> : ChartScatterSeries<TModel, TValue>, IChartScatterLineSeries where TModel : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartScatterLineSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        /// <param name="expressionXValue">The X expression.</param>
        /// <param name="expressionYValue">The Y expression.</param>
        public ChartScatterLineSeries(Chart<TModel> chart, Expression<Func<TModel, TValue>> xValueExpression, Expression<Func<TModel, TValue>> yValueExpression)
            : base(chart, xValueExpression, yValueExpression)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartScatterLineSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        /// <param name="data">The data.</param>
        public ChartScatterLineSeries(Chart<TModel> chart, IEnumerable data)
            : base(chart, data)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartScatterLineSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        public ChartScatterLineSeries(Chart<TModel> chart)
            : base(chart)
        {
        }

        /// <summary>
        /// The chart line width.
        /// </summary>
        public double Width
        {
            get;
            set;
        }

        /// <summary>
        /// The chart line dashType.
        /// </summary>
        public ChartDashType DashType
        {
            get;
            set;
        }

        /// <summary>
        /// The behavior for handling missing values in scatter line series.
        /// </summary>
        public ChartScatterLineMissingValues MissingValues
        {
            get;
            set;
        }

        protected override void Initialize()
        {
            base.Initialize();
            Width = ChartDefaults.ScatterLineSeries.Width;
            DashType = ChartDefaults.ScatterLineSeries.DashType;
            MissingValues = ChartDefaults.ScatterLineSeries.MissingValues;
        }

        /// <summary>
        /// Creates a serializer for the series
        /// </summary>
        public override IChartSerializer CreateSerializer()
        {
            return new ChartScatterLineSeriesSerializer(this);
        }
    }
}