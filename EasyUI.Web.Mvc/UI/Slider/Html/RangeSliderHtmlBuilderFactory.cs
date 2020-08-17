




namespace EasyUI.Web.Mvc.UI.Html
{
    public class RangeSliderHtmlBuilderFactory : IRangeSliderHtmlBuilderFactory
    {
        public IRangeSliderHtmlBuilder Create(RangeSliderRenderingData renderingData)
        {
            return new RangeSliderHtmlBuilder(renderingData);
        }
    }
}