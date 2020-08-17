




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartTitleSerializer : IChartSerializer
    {
        private readonly ChartTitle title;

        public ChartTitleSerializer(ChartTitle title)
        {
            this.title = title;
        }

        public virtual IDictionary<string, object> Serialize()
        {
            var result = new Dictionary<string, object>();
            
            FluentDictionary.For(result)
                .Add("text", title.Text, string.Empty)
                .Add("font", title.Font, ChartDefaults.Title.Font)
                .Add("position", title.Position.ToString().ToLowerInvariant(), ChartDefaults.Title.Position.ToString().ToLowerInvariant())
                .Add("align", title.Align.ToString().ToLowerInvariant(), ChartDefaults.Title.Align.ToString().ToLowerInvariant())
                .Add("margin", title.Margin.CreateSerializer().Serialize(), ShouldSerializeMargin)
                .Add("padding", title.Padding.CreateSerializer().Serialize(), ShouldSerializePadding)
                .Add("border", title.Border.CreateSerializer().Serialize(), ShouldSerializeBorder)
                .Add("background", title.Background, string.Empty)
                .Add("visible", title.Visible, ChartDefaults.Title.Visible);

            return result;
        }

        private bool ShouldSerializeMargin()
        {
            return  title.Margin.Top != ChartDefaults.Title.Margin ||
                    title.Margin.Right != ChartDefaults.Title.Margin ||
                    title.Margin.Bottom != ChartDefaults.Title.Margin ||
                    title.Margin.Left != ChartDefaults.Title.Margin;
        }

        private bool ShouldSerializePadding()
        {
            return title.Padding.Top != ChartDefaults.Title.Padding ||
                   title.Padding.Right != ChartDefaults.Title.Padding ||
                   title.Padding.Bottom != ChartDefaults.Title.Padding ||
                   title.Padding.Left != ChartDefaults.Title.Padding;
        }

        private bool ShouldSerializeBorder()
        {
            return title.Border.Color.CompareTo(ChartDefaults.Title.Border.Color) != 0 ||
                   title.Border.Width != ChartDefaults.Title.Border.Width;
        }
    }
}