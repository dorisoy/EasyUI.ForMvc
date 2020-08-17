// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using EasyUI.Web.Mvc.Infrastructure;
    
    public class GridButtonImageDecorator : IGridButtonBuilderDecorator
    {
        private readonly IGridButtonBuilder button;

        public GridButtonImageDecorator(IGridButtonBuilder button)
        {
            this.button = button;
        }

        public void Apply(IHtmlNode parent)
        {
            var span = new HtmlElement("span")
                            .AddClass(UIPrimitives.Icon, button.SpriteCssClass);

            span.Attributes(button.ImageHtmlAttributes);

            span.AppendTo(parent);
        }
    }
}