




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartScatterLineSeriesSerializer : ChartScatterSeriesSerializer
    {
        private readonly IChartScatterLineSeries series;

        public ChartScatterLineSeriesSerializer(IChartScatterLineSeries series)
            : base(series)
        {
            this.series = series;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();

            FluentDictionary.For(result)
                .Add("type", "scatterLine")
                .Add("width", series.Width, ChartDefaults.ScatterLineSeries.Width)
                .Add("dashType", series.DashType.ToString().ToLowerInvariant(), ChartDefaults.ScatterLineSeries.DashType.ToString().ToLowerInvariant())
                .Add("missingValues", series.MissingValues.ToString().ToLowerInvariant(),
                                      ChartDefaults.ScatterLineSeries.MissingValues.ToString().ToLowerInvariant());

            return result;
        }
    }
}