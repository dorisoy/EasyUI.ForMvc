




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartSeriesDefaultsSerializer : IChartSerializer
    {
        private readonly IChartSeriesDefaults seriesDefaults;

        public ChartSeriesDefaultsSerializer(IChartSeriesDefaults seriesDefaults)
        {
            this.seriesDefaults = seriesDefaults;
        }

        public virtual IDictionary<string, object> Serialize()
        {
            var barData = seriesDefaults.Bar.CreateSerializer().Serialize();
            barData.Remove("type");

            var columnData = seriesDefaults.Column.CreateSerializer().Serialize();
            columnData.Remove("type");

            var lineData = seriesDefaults.Line.CreateSerializer().Serialize();
            lineData.Remove("type");

            var pieData = seriesDefaults.Pie.CreateSerializer().Serialize();
            pieData.Remove("type");

            var scatterData = seriesDefaults.Scatter.CreateSerializer().Serialize();
            scatterData.Remove("type");

            var scatterLineData = seriesDefaults.ScatterLine.CreateSerializer().Serialize();
            scatterLineData.Remove("type");

            var result = new Dictionary<string, object>();
            FluentDictionary.For(result)
                  .Add("bar", barData, () => barData.Count > 0)
                  .Add("column", columnData, () => columnData.Count > 0)
                  .Add("line", lineData, () => lineData.Count > 0)
                  .Add("pie", pieData, () => pieData.Count > 0)
                  .Add("scatter", scatterData, () => scatterData.Count > 0)
                  .Add("scatterLine", scatterLineData, () => scatterLineData.Count > 0);

            return result;
        }
    }
}
