// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridPagerBuilder
    {
        IHtmlNode Create(GridPagerData section);
        
        IHtmlNode CreateRefreshButton(GridPagerData pagerData);
    }
}