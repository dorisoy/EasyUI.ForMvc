namespace EasyUI.Web.Mvc.Examples
{
    using System.Web;
    using System.Web.Mvc;

    public partial class EditorController : Controller
    {
        [ValidateInput(false)]
        public ActionResult Accessibility(string editor)
        {
            if (editor != null)
            {
                ViewData["editor"] = editor;

                ViewData["value"] = HttpUtility.HtmlEncode(editor.IndentHtml());
            }
            return View();
        }
    }
}