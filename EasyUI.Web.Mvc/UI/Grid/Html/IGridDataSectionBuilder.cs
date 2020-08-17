// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridDataSectionBuilder
    {
        IHtmlNode CreateBody(GridRenderingData data);

        IHtmlNode CreateHeader(GridRenderingData data);

        IHtmlNode CreateFooter(GridRenderingData data);
    }
}
