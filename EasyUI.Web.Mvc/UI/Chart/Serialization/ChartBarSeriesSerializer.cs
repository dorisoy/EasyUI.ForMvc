




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartBarSeriesSerializer : ChartSeriesSerializer
    {
        private readonly IChartBarSeries series;

        public ChartBarSeriesSerializer(IChartBarSeries series)
            : base(series)
        {
            this.series = series;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();

            FluentDictionary.For(result)
                .Add("type", series.Orientation == ChartBarSeriesOrientation.Horizontal ? "bar" : "column")
                .Add("stack", series.Stacked, false)
                .Add("gap", series.Gap, ChartDefaults.BarSeries.Gap)
                .Add("spacing", series.Spacing, ChartDefaults.BarSeries.Spacing)
                .Add("field", series.Member, () => { return series.Data == null && series.Member != null; })
                .Add("data", series.Data, () => { return series.Data != null; })
                .Add("border", series.Border.CreateSerializer().Serialize(), ShouldSerializeBorder)
                .Add("color", series.Color, string.Empty)
                .Add("overlay", series.Overlay.Value, () => { return series.Overlay != ChartDefaults.BarSeries.Overlay; });

            var labelsData = series.Labels.CreateSerializer().Serialize();
            if (labelsData.Count > 0)
            {
                result.Add("labels", labelsData);
            }

            return result;
        }

        private bool ShouldSerializeBorder()
        {
            return series.Border.Color.CompareTo(ChartDefaults.BarSeries.Border.Color) != 0 ||
                   series.Border.Width != ChartDefaults.BarSeries.Border.Width ||
                   series.Border.DashType != ChartDefaults.BarSeries.Border.DashType;
        }
    }
}