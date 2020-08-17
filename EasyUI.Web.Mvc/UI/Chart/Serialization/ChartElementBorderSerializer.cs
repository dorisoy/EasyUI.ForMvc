




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartElementBorderSerializer : IChartSerializer
    {
        private readonly ChartElementBorder border;

        public ChartElementBorderSerializer(ChartElementBorder border)
        {
            this.border = border;
        }

        public virtual IDictionary<string, object> Serialize()
        {
            var result = new Dictionary<string, object>();

            FluentDictionary.For(result)
                .Add("width", border.Width)
                .Add("dashType", border.DashType.ToString().ToLowerInvariant())
                .Add("color", border.Color);

            return result;
        }
    }
}