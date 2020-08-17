namespace EasyUI.Web.Mvc.JavaScriptTests.Controllers
{
    using System.Web.Mvc;

    public class TabStripController : Controller
    {
        public ActionResult AjaxLoading()
        {
            return View();
        }

        public ActionResult ClientAPI() 
        {
            return View();
        }

        public ActionResult Serialization()
        {
            return View();
        }

        [HttpPost]
        public ActionResult AjaxView1()
        {
            return PartialView();
        }

        [HttpPost]
        public ActionResult AjaxView2()
        {
            return PartialView();
        }
    }
}
