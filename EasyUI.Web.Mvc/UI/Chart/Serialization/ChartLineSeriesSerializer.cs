




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartLineSeriesSerializer : ChartSeriesSerializer
    {
        private readonly IChartLineSeries series;

        public ChartLineSeriesSerializer(IChartLineSeries series)
            : base(series)
        {
            this.series = series;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();

            FluentDictionary.For(result)
                .Add("type", "line")
                .Add("stack", series.Stacked, false)
                .Add("field", series.Member, () => { return series.Data == null && series.Member != null; })
                .Add("data", series.Data, () => { return series.Data != null; })
                .Add("width", series.Width, ChartDefaults.LineSeries.Width)
                .Add("color", series.Color, string.Empty)
                .Add("dashType", series.DashType.ToString().ToLowerInvariant(), ChartDefaults.LineSeries.DashType.ToString().ToLowerInvariant())
                .Add("missingValues", series.MissingValues.ToString().ToLowerInvariant(),
                                      ChartDefaults.LineSeries.MissingValues.ToString().ToLowerInvariant());

            var labelsData = series.Labels.CreateSerializer().Serialize();
            if (labelsData.Count > 0)
            {
                result.Add("labels", labelsData);
            }

            var markers = series.Markers.CreateSerializer().Serialize();
            if (markers.Count > 0)
            {
                result.Add("markers", markers);
            }

            return result;
        }
    }
}