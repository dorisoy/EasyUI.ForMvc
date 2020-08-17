




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;

    internal class ChartAxisLabelsSerializer : ChartLabelsBase
    {
        private readonly ChartLabels axisLabels;

        public ChartAxisLabelsSerializer(ChartLabels axisLabels)
            : base(axisLabels)
        {
            this.axisLabels = axisLabels;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();

            return result;
        }
    }
}