namespace EasyUI.Web.Mvc.JavaScriptTests.Controllers
{
    using System.Web.Mvc;

    public class SplitterController : Controller
    {
        public ActionResult PaneSizing()
        {
            return View();
        }

        public ActionResult ClientCreation()
        {
            return View();
        }

        public ActionResult ClientEvents()
        {
            return View();
        }

        public ActionResult PaneResizing()
        {
            return View();
        }

        public ActionResult ExpandCollapse()
        {
            return View();
        }

        public ActionResult ClientSideApi()
        {
            return View();
        }

        public ActionResult LoadOnDemand()
        {
            return View();
        }

        [HttpPost]
        public ActionResult LoadOnDemand(string echo)
        {
            return Content(echo);
        }
    }
}
