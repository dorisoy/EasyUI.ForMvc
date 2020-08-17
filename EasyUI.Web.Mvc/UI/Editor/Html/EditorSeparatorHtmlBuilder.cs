



namespace EasyUI.Web.Mvc.UI.Html
{
    using EasyUI.Web.Mvc.Infrastructure;
    
    public class EditorSeparatorHtmlBuilder : HtmlBuilderBase
    {
        private readonly EditorSeparator separator;

        public EditorSeparatorHtmlBuilder(EditorSeparator separator)
        {
            this.separator = separator;
        }

        protected override IHtmlNode BuildCore()
        {
            return new HtmlElement("li")
                    .AddClass("t-separator");
        }
    }
}
