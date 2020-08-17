namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public partial class SplitterController : Controller
    {
        public ActionResult NestingComponents(string view)
        {
            ViewData["view"] = view ?? "sortedByName";

            return View();
        }
    }
}