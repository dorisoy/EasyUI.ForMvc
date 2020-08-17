




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartSpacingSerializer : IChartSerializer
    {
        private readonly ChartSpacing spacing;

        public ChartSpacingSerializer(ChartSpacing spacing)
        {
            this.spacing = spacing;
        }

        public virtual IDictionary<string, object> Serialize()
        {
            var result = new Dictionary<string, object>();
            
            FluentDictionary.For(result)
                .Add("top", spacing.Top)
                .Add("right", spacing.Right)
                .Add("bottom", spacing.Bottom)
                .Add("left", spacing.Left);

            return result;
        }
    }
}