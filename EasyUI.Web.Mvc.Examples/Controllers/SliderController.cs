namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.UI;

    [AutoPopulateSourceCode]
    [PopulateProductSiteMap(SiteMapName = "examples", ViewDataKey = "easyui.mvc.examples")]
    public partial class SliderController : Controller
    {
        /* left only because of the attributes, which are example-agnostic */
    }

    public class SliderAttributes
    {
        public double? Value { get; set; }
        public double? MinValue { get; set; }
        public double? MaxValue { get; set; }
        public double? SmallStep { get; set; }
        public double? LargeStep { get; set; }
        public bool? ShowButtons { get; set; }
        public SliderTickPlacement? TickPlacement { get; set; }
        public SliderOrientation? SliderOrientation { get; set; }
    }

    public class RangeSliderAttributes
    {
        public double? SelectionStart { get; set; }
        public double? SelectionEnd { get; set; }
        public double? MinValue { get; set; }
        public double? MaxValue { get; set; }
        public double? SmallStep { get; set; }
        public double? LargeStep { get; set; }
        public SliderTickPlacement? TickPlacement { get; set; }
        public SliderOrientation? SliderOrientation { get; set; }
    }
}