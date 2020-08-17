﻿




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartScatterSeriesSerializer : ChartSeriesSerializer
    {
        private readonly IChartScatterSeries series;

        public ChartScatterSeriesSerializer(IChartScatterSeries series)
            : base(series)
        {
            this.series = series;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();

            FluentDictionary.For(result)
                .Add("type", "scatter")
                .Add("xField", series.XMember, () => { return series.Data == null && series.XMember != null; })
                .Add("yField", series.YMember, () => { return series.Data == null && series.YMember != null; })
                .Add("data", series.Data, () => { return series.Data != null; })
                .Add("color", series.Color, string.Empty);

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