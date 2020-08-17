




namespace EasyUI.Web.Mvc.UI
{
    using EasyUI.Web.Mvc.UI.Html;

    public class EditorBreak : IEditorTool
    {
        public IHtmlBuilder CreateHtmlBuilder()
        {
            return new EditorBreakHtmlBuilder(this);
        }
    }
}
