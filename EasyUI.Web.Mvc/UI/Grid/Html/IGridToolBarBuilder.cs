// (c) Copyright 2002-2009 EasyUI 





namespace EasyUI.Web.Mvc.UI.Html
{
    using System.Collections.Generic;

    public interface IGridToolBarBuilder
    {
        IHtmlNode CreateToolBar(IEnumerable<IGridButtonBuilder> commandBuilders);

        IHtmlNode CreateToolBar(HtmlTemplate template);
    }
}
