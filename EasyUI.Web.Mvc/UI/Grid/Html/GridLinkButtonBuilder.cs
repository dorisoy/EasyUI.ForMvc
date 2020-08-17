// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    /// <summary>
    /// 
    /// </summary>
    public class GridLinkButtonBuilder : GridButtonBuilderBase
    {
        protected override void ApplyButtonAttributes(IHtmlNode button, object dataItem)
        {
            button.Attribute("href", Url(dataItem));
        }

        protected override string ButtonTagName
        {
            get
            {
                return "a";
            }
        }
    }
}
