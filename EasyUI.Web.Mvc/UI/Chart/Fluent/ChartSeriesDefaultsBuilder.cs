﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using EasyUI.Web.Mvc.Infrastructure;

    public class ChartSeriesDefaultsBuilder<TModel> : IHideObjectMembers where TModel : class
    {
        private Chart<TModel> Chart;

        public ChartSeriesDefaultsBuilder(Chart<TModel> chart)
        {
            Guard.IsNotNull(chart, "chart");

            Chart = chart;
        }

        /// <summary>
        /// Defines the default settings for bar series.
        /// </summary>
        public virtual ChartBarSeriesBuilder<TModel> Bar()
        {
            return new ChartBarSeriesBuilder<TModel>(Chart.SeriesDefaults.Bar);
        }

        /// <summary>
        /// Defines the default settings for column series.
        /// </summary>
        public virtual ChartBarSeriesBuilder<TModel> Column()
        {
            return new ChartBarSeriesBuilder<TModel>(Chart.SeriesDefaults.Column);
        }

        /// <summary>
        /// Defines the default settings for line series.
        /// </summary>
        public virtual ChartLineSeriesBuilder<TModel> Line()
        {
            return new ChartLineSeriesBuilder<TModel>(Chart.SeriesDefaults.Line);
        }

        /// <summary>
        /// Defines the default settings for pie series.
        /// </summary>
        public virtual ChartPieSeriesBuilder<TModel> Pie()
        {
            return new ChartPieSeriesBuilder<TModel>(Chart.SeriesDefaults.Pie);
        }

        /// <summary>
        /// Defines the default settings for scatter series.
        /// </summary>
        public virtual ChartScatterSeriesBuilder<TModel> Scatter()
        {
            return new ChartScatterSeriesBuilder<TModel>(Chart.SeriesDefaults.Scatter);
        }

        /// <summary>
        /// Defines the default settings for scatter line series.
        /// </summary>
        public virtual ChartScatterLineSeriesBuilder<TModel> ScatterLine()
        {
            return new ChartScatterLineSeriesBuilder<TModel>(Chart.SeriesDefaults.ScatterLine);
        }
    }
}