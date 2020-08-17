




namespace EasyUI.Web.Mvc.UI.Html
{
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.UI;
    
    public class EditorToolGroupHtmlBuilder : HtmlBuilderBase
    {
        private readonly EditorToolGroup group;

        public EditorToolGroupHtmlBuilder(EditorToolGroup group)
        {
            this.group = group;
        }

        protected override IHtmlNode BuildCore()
        {
            var ul = new HtmlElement("ul")
                .AddClass("t-editor-toolbar");

            group.Tools.Each(tool =>
            {
                tool.CreateHtmlBuilder()
                    .Build()
                    .AppendTo(ul);
            });

            return ul;
        }
    }
}
