// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using EasyUI.Web.Mvc.Infrastructure;

    public class GridFormButtonBuilder : GridButtonBuilder
    {
        public override IHtmlNode Create(object dataItem)
        {
            var form = new HtmlElement("form")
                        .AddClass(UIPrimitives.Grid.ActionForm)
                        .Attribute("method", "post")
                        .Attribute("action", Url(dataItem));

            var div = new HtmlElement("div");
            
            div.AppendTo(form);
            
            var button = base.Create(dataItem);
            
            button.AppendTo(div);

            return form;
        }
    }
}