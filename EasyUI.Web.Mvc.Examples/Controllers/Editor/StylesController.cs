namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public partial class EditorController : Controller
    {
        [SourceCodeFile("editorStyles.css", "~/Content/Editor/Styles/editorStyles.css")]
        public ActionResult Styles()
        {
            return View();
        }
    }
}