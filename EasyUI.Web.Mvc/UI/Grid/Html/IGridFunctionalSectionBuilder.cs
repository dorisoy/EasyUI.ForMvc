// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridFunctionalSectionBuilder
    {
        IHtmlNode CreateToolBar(GridToolBarData toolBarData);
        
        IHtmlNode CreateGroupHeader(GridGroupingData renderingData);
        
        IHtmlNode CreatePager(GridPagerData pagerSection);

        IHtmlNode CreateRefreshButton(GridPagerData pagerData);
    }
}