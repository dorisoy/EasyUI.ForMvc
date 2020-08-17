




namespace EasyUI.Web.Mvc.UI.Html
{
    using EasyUI.Web.Mvc.Infrastructure;
    
    public class EditorDropDownHtmlBuilder : HtmlBuilderBase
    {
        private readonly EditorDropDown dropDown;

        public EditorDropDownHtmlBuilder(EditorDropDown dropDown)
        {
            this.dropDown = dropDown;
        }

        protected override IHtmlNode BuildCore()
        {
            var li = new HtmlElement("li")
                    .AddClass("t-editor-dropdown");

            var builder = new DropDownListHtmlBuilder(dropDown);

            IHtmlNode rootTag = builder.Build();

            rootTag.AppendTo(li);
            
            return li;
        }
    }
}