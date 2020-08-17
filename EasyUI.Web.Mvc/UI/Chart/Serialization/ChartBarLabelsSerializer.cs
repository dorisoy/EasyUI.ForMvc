




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartBarLabelsSerializer : ChartLabelsBase
    {
        private readonly ChartBarLabels barLabels;

        public ChartBarLabelsSerializer(ChartBarLabels barLabels)
            : base(barLabels)
        {
            this.barLabels = barLabels;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();
            
            FluentDictionary.For(result)
                .Add("position", barLabels.Position.ToString().ToCamelCase(), ChartDefaults.BarSeries.Labels.Position.ToString().ToCamelCase());

            return result;
        }
    }
}