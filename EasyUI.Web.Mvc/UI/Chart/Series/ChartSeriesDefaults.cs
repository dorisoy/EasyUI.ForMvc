﻿




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents the default settings for all series in the <see cref="EasyUI.Web.Mvc.UI.Chart{T}"/> component
    /// </summary>
    /// <typeparam name="T">The type of the data item</typeparam>
    public class ChartSeriesDefaults<T> : ChartSeriesBase<T>, IChartSeriesDefaults where T : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartSeriesDefaults{T}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        public ChartSeriesDefaults(Chart<T> chart)
            : base(chart)
        {
            Bar = new ChartBarSeries<T, object>(chart);
            Column = new ChartBarSeries<T, object>(chart);
            Line = new ChartLineSeries<T, object>(chart);
            Pie = new ChartPieSeries<T, object>(chart);
            Scatter = new ChartScatterSeries<T, object>(chart);
            ScatterLine = new ChartScatterLineSeries<T, object>(chart);
        }

        /// <summary>
        /// The default settings for all bar series.
        /// </summary>
        public IChartBarSeries Bar
        {
            get;
            private set;
        }

        /// <summary>
        /// The default settings for all column series.
        /// </summary>
        public IChartBarSeries Column
        {
            get;
            private set;
        }

        /// <summary>
        /// The default settings for all line series.
        /// </summary>
        public IChartLineSeries Line
        {
            get;
            private set;
        }

        /// <summary>
        /// The default settings for all pie series.
        /// </summary>
        public IChartPieSeries Pie
        {
            get;
            private set;
        }

        /// <summary>
        /// The default settings for all scatter series.
        /// </summary>
        public IChartScatterSeries Scatter
        {
            get;
            private set;
        }

        /// <summary>
        /// The default settings for all scatter line series.
        /// </summary>
        public IChartScatterLineSeries ScatterLine
        {
            get;
            private set;
        }

        /// <summary>
        /// Creates a serializer for the series defaults
        /// </summary>
        public override IChartSerializer CreateSerializer()
        {
            return new ChartSeriesDefaultsSerializer(this);
        }
    }
}