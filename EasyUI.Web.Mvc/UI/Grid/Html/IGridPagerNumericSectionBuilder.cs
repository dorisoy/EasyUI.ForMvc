// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridPagerNumericSectionBuilder
    {
        IHtmlNode Create(IGridUrlBuilder urlBuilder, int currentPage, int pageCount);
    }
}