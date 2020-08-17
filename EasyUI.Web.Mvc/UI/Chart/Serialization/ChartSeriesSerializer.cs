




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartSeriesSerializer : IChartSerializer
    {
        private readonly IChartSeries series;

        public ChartSeriesSerializer(IChartSeries series)
        {
            this.series = series;
        }

        public virtual IDictionary<string, object> Serialize()
        {
            var result = new Dictionary<string, object>();
            FluentDictionary.For(result)
                  .Add("name", series.Name, string.Empty)
                  .Add("opacity", series.Opacity, 1);

            return result;
        }
    }
}
