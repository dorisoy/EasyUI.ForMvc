




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartPieConnectorsSerializer : IChartSerializer
    {
        private readonly ChartPieConnectors pieConnectors;

        public ChartPieConnectorsSerializer(ChartPieConnectors pieConnectors)
        {
            this.pieConnectors = pieConnectors;
        }

        public virtual IDictionary<string, object> Serialize()
        {
            var result = new Dictionary<string, object>();

            FluentDictionary.For(result)
                .Add("width", pieConnectors.Width, ChartDefaults.PieSeries.Connectors.Width)
                .Add("color", pieConnectors.Color, ChartDefaults.PieSeries.Connectors.Color)
                .Add("padding", pieConnectors.Padding, ChartDefaults.PieSeries.Connectors.Padding);

            return result;
        }
    }
}