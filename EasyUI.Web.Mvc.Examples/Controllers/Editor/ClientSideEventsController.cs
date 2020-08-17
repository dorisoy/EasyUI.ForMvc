namespace EasyUI.Web.Mvc.Examples
{
    using System.Web;
    using System.Web.Mvc;

    public partial class EditorController : Controller
    {
        public ActionResult ClientSideEvents(string Editor)
        {
            ViewData["Editor"] = HttpUtility.HtmlDecode(Editor);
            return View();
        }
    }
}