




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartLabelsBase : IChartSerializer
    {
        private readonly IChartLabels labels;

        public ChartLabelsBase(IChartLabels labels)
        {
            this.labels = labels;
        }

        public virtual IDictionary<string, object> Serialize()
        {
            var result = new Dictionary<string, object>();
            
            FluentDictionary.For(result)
                .Add("font", labels.Font, ChartDefaults.Labels.Font)
                .Add("margin", labels.Margin.CreateSerializer().Serialize(), ShouldSerializeMargin)
                .Add("padding", labels.Padding.CreateSerializer().Serialize(), ShouldSerializePadding)
                .Add("border", labels.Border.CreateSerializer().Serialize(), ShouldSerializeBorder)
                .Add("color", labels.Color, ChartDefaults.Labels.Color)
                .Add("background", labels.Background, string.Empty)
                .Add("template", labels.Template, string.Empty)
                .Add("format", labels.Format, string.Empty)
                .Add("rotation", labels.Rotation, ChartDefaults.Labels.Rotation)
                .Add("opacity", labels.Opacity, ChartDefaults.Labels.Opacity)
                .Add("visible", labels.Visible, ChartDefaults.Labels.Visible);

            return result;
        }

        private bool ShouldSerializeMargin()
        {
            return labels.Margin.Top != ChartDefaults.Labels.Margin ||
                   labels.Margin.Right != ChartDefaults.Labels.Margin ||
                   labels.Margin.Bottom != ChartDefaults.Labels.Margin ||
                   labels.Margin.Left != ChartDefaults.Labels.Margin;
        }

        private bool ShouldSerializePadding()
        {
            return labels.Padding.Top != ChartDefaults.Labels.Padding ||
                   labels.Padding.Right != ChartDefaults.Labels.Padding ||
                   labels.Padding.Bottom != ChartDefaults.Labels.Padding ||
                   labels.Padding.Left != ChartDefaults.Labels.Padding;
        }

        private bool ShouldSerializeBorder()
        {
            return labels.Border.Color.CompareTo(ChartDefaults.Labels.Border.Color) != 0 ||
                   labels.Border.Width != ChartDefaults.Labels.Border.Width ||
                   labels.Border.DashType != ChartDefaults.Labels.Border.DashType;
        }
    }
}