namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public partial class TabStripController : Controller
    {
        public ActionResult Accessibility(string selectedIndex)
        {
            ViewData["selectedIndex"] = selectedIndex;
            return View();
        }
    }
}