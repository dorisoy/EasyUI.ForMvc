namespace EasyUI.Web.Mvc.JavaScriptTests.Controllers
{
    using System.Web.Mvc;

    public class WindowController : Controller
    {
        public ActionResult ClientCreation()
        {
            return View();
        }

        public ActionResult ClientSideApi()
        {
            return View();
        }

        [HttpGet]
        public ActionResult Blank()
        {
            return Content("");
        }
    }
}
