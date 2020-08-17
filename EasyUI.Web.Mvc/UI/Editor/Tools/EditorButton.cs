



namespace EasyUI.Web.Mvc.UI
{
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.UI.Html;
    
    public class EditorButton : IEditorTool
    {
        public EditorButton(string text)
        {
            Guard.IsNotNullOrEmpty(text, "text");

            Text = text.ToCamelCase();
            CssClass = "t-" + Text;
        }

        public string Text
        {
            get;
            set;
        }
        
        public string CssClass
        {
            get;
            set;
        }

        public IHtmlBuilder CreateHtmlBuilder()
        {
            return new EditorButtonHtmlBuilder(this);
        }
    }
}
