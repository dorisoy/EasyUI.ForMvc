




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartTooltipSerializer : IChartSerializer
    {
        private readonly ChartTooltip chartTooltip;

        public ChartTooltipSerializer(ChartTooltip chartTooltip)
        {
            this.chartTooltip = chartTooltip;
        }

        public IDictionary<string, object> Serialize()
        {
            var result = new Dictionary<string, object>();
            
            FluentDictionary.For(result)
                .Add("font", chartTooltip.Font, ChartDefaults.Tooltip.Font)
                .Add("padding", chartTooltip.Padding.CreateSerializer().Serialize(), ShouldSerializePadding)
                .Add("border", chartTooltip.Border.CreateSerializer().Serialize(), ShouldSerializeBorder)
                .Add("color", chartTooltip.Color, string.Empty)
                .Add("background", chartTooltip.Background, string.Empty)
                .Add("format", chartTooltip.Format, string.Empty)
                .Add("template", chartTooltip.Template, string.Empty)
                .Add("opacity", chartTooltip.Opacity, ChartDefaults.Tooltip.Opacity)
                .Add("visible", chartTooltip.Visible, ChartDefaults.Tooltip.Visible);

            return result;
        }

        private bool ShouldSerializePadding()
        {
            return chartTooltip.Padding.Top != ChartDefaults.Tooltip.Padding ||
                   chartTooltip.Padding.Right != ChartDefaults.Tooltip.Padding ||
                   chartTooltip.Padding.Bottom != ChartDefaults.Tooltip.Padding ||
                   chartTooltip.Padding.Left != ChartDefaults.Tooltip.Padding;
        }

        private bool ShouldSerializeBorder()
        {
            return chartTooltip.Border.Color.CompareTo(ChartDefaults.Tooltip.Border.Color) != 0 ||
                   chartTooltip.Border.Width != ChartDefaults.Tooltip.Border.Width ||
                   chartTooltip.Border.DashType != ChartDefaults.Tooltip.Border.DashType;
        }
    }
}