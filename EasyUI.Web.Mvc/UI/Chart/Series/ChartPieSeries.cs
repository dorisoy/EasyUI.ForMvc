﻿




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
    /// Represents chart pie series
    /// </summary>
    /// <typeparam name="TModel">The Chart model type</typeparam>
    /// <typeparam name="TValue">The value type</typeparam>
    public class ChartPieSeries<TModel, TValue> : ChartSeriesBase<TModel>, IChartPieSeries where TModel : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartPieSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        /// <param name="expressionValue">The value expression.</param>
        /// <param name="expressionCategory">The category expression.</param>
        /// <param name="expressionColor">The color expression.</param>
        /// <param name="expressionExplode">The explode expression.</param>
        public ChartPieSeries(Chart<TModel> chart, Expression<Func<TModel, TValue>> expressionValue, Expression<Func<TModel, string>> expressionCategory, Expression<Func<TModel, string>> expressionColor, Expression<Func<TModel, bool>> expressionExplode)
            : base(chart)
        {
            Guard.IsNotNull(expressionValue, "expressionValue");

            if (typeof(TModel).IsPlainType() && !expressionValue.IsBindable())
            {
                throw new InvalidOperationException(TextResource.MemberExpressionRequired);
            }

            Expression = expressionValue;
            Member = expressionValue.MemberWithoutInstance();
            Value = expressionValue.Compile();
            if (expressionCategory != null)
            {
                Category = expressionCategory.Compile();
                CategoryMember = expressionCategory.MemberWithoutInstance();
            }

            if (expressionExplode != null)
            {
                Explode = expressionExplode.Compile();
                ExplodeMember = expressionExplode.MemberWithoutInstance();
            }

            if (expressionColor != null)
            {
                Color = expressionColor.Compile();
                ColorMember = expressionColor.MemberWithoutInstance();
            }

            if (string.IsNullOrEmpty(Name))
            {
                Name = Member.AsTitle();
            }

            Initialize();
            BindChartData();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartPieSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        /// <param name="data">The data.</param>
        public ChartPieSeries(Chart<TModel> chart, IEnumerable data)
            : base(chart)
        {
            Guard.IsNotNull(data, "data");

            Data = data;
            Initialize();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartPieSeries{TModel, TValue}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        public ChartPieSeries(Chart<TModel> chart)
            : base(chart)
        {
            Initialize();
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
        /// Gets the model data category member name.
        /// </summary>
        /// <value>The model data category member name.</value>
        public string CategoryMember
        {
            get;
            set;
        }

        /// <summary>
        /// Gets the model data explode member name.
        /// </summary>
        /// <value>The model data explode member name.</value>
        public string ExplodeMember
        {
            get;
            set;
        }

        /// <summary>
        /// Gets the model data color member name.
        /// </summary>
        /// <value>The model data color member name.</value>
        public string ColorMember
        {
            get;
            set;
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
        /// Gets a function which returns the category of the property to which the column is bound to.
        /// </summary>
        public Func<TModel, string> Category
        {
            get;
            private set;
        }

        /// <summary>
        /// Gets a function which returns the explode of the property to which the column is bound to.
        /// </summary>
        public Func<TModel, bool> Explode
        {
            get;
            private set;
        }

        /// <summary>
        /// Gets a function which returns the color of the property to which the column is bound to.
        /// </summary>
        public new Func<TModel, string> Color
        {
            get;
            set;
        }

        /// <summary>
        /// Gets the pie chart data labels configuration
        /// </summary>
        public ChartPieLabels Labels
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the pie border
        /// </summary>
        public ChartElementBorder Border
        {
            get;
            set;
        }

        /// <summary>
        /// The pie chart data configuration.
        /// </summary>
        public IEnumerable Data
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the effects overlay.
        /// </summary>
        public ChartPieSeriesOverlay Overlay
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the padding of the chart.
        /// </summary>
        public int Padding
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the start angle of the first pie segment.
        /// </summary>
        public int StartAngle
        {
            get;
            set;
        }

        /// <summary>
        /// Gets the pie chart connectors configuration
        /// </summary>
        public ChartPieConnectors Connectors
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
                var dataList = new List<IDictionary<string, object>>();

                foreach (var dataPoint in Chart.DataSource)
                {
                    var pieChartPoint = new Dictionary<string, object>();
                    var fluentDictionary = FluentDictionary.For(pieChartPoint);

                    fluentDictionary.Add("value", Value(dataPoint));
                    if (Category != null)
                    {
                        fluentDictionary.Add("category", Category(dataPoint), (string)null);
                    }

                    if (Color != null)
                    {
                        fluentDictionary.Add("color", Color(dataPoint), (string)null);
                    }

                    if (Explode != null)
                    {
                        fluentDictionary.Add("explode", Explode(dataPoint), false);
                    }

                    dataList.Add(pieChartPoint);
                }

                Data = dataList;
            }
        }

        private void Initialize()
        {
            Labels = new ChartPieLabels();
            Connectors = new ChartPieConnectors();
            Border = new ChartElementBorder(
                    ChartDefaults.PieSeries.Border.Width,
                    ChartDefaults.PieSeries.Border.Color,
                    ChartDefaults.PieSeries.Border.DashType);
            Padding = ChartDefaults.PieSeries.Padding;
            StartAngle = ChartDefaults.PieSeries.StartAngle;
        }

        /// <summary>
        /// Creates a serializer for the series
        /// </summary>
        public override IChartSerializer CreateSerializer()
        {
            return new ChartPieSeriesSerializer(this);
        }
    }
}