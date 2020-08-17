// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridPagerButtonFactory
    {
        IHtmlNode CreateButton(GridPagerButtonType buttonType, string text, bool enabled, string url);
    }

    public enum GridPagerButtonType
    {
        Icon = 0,
        NumericLink
    }
}