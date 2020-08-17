




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartPointLabelsSerializer : ChartLabelsBase
    {
        private readonly ChartPointLabels lineLabels;

        public ChartPointLabelsSerializer(ChartPointLabels lineLabels)
            : base(lineLabels)
        {
            this.lineLabels = lineLabels;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();

            FluentDictionary.For(result)
                .Add("position", lineLabels.Position.ToString().ToCamelCase(), ChartDefaults.PointLabels.Position.ToString().ToCamelCase());

            return result;
        }
    }
}