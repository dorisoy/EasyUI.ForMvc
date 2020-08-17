// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    public class GridHiddenCellBuilderDecorator : IGridCellBuilderDecorator
    {
        public void Decorate(IHtmlNode td)
        {
            td.Css("display", "none");              
        }
    }
}
