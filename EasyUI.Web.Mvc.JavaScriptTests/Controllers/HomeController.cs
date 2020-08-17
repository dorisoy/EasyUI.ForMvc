namespace EasyUI.Web.Mvc.JavaScriptTests.Controllers
{
    using System.Linq;
    using System.Reflection;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.JavaScriptTests.Extensions;

    [HandleError]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            string requestedController = "";

            if (Request.RawUrl.LastIndexOf("?") > 0)
            {
                requestedController = Request.RawUrl.Substring(Request.RawUrl.LastIndexOf("?") + 1);
            }

            ViewData["Controllers"] =
                from type in Assembly.GetExecutingAssembly().GetTypes()
                where type.IsClass && type.Namespace == "EasyUI.Web.Mvc.JavaScriptTests.Controllers" && type.Name != "HomeController"
                where requestedController == "" || type.GetName().ToLowerInvariant() == requestedController.ToLowerInvariant()
                orderby type.Name
                select type;

            return View();
        }
    }
}
