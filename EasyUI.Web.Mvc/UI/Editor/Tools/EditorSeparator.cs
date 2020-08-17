




namespace EasyUI.Web.Mvc.UI
{
    using EasyUI.Web.Mvc.UI.Html;
    
    public class EditorSeparator : IEditorTool
    {
        public IHtmlBuilder CreateHtmlBuilder()
        {
            return new EditorSeparatorHtmlBuilder(this);
        }
    }
}
