




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartPieLabelsSerializer : ChartLabelsBase
    {
        private readonly ChartPieLabels pieLabels;

        public ChartPieLabelsSerializer(ChartPieLabels pieLabels)
            : base (pieLabels)
        {
            this.pieLabels = pieLabels;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();

            FluentDictionary.For(result)
                .Add("align", pieLabels.Align.ToString().ToCamelCase(), ChartDefaults.PieSeries.Labels.Align.ToString().ToCamelCase())
                .Add("position", pieLabels.Position.ToString().ToCamelCase(), ChartDefaults.PieSeries.Labels.Position.ToString().ToCamelCase())
                .Add("distance", pieLabels.Distance, ChartDefaults.PieSeries.Labels.Distance);

            return result;
        }
    }
}