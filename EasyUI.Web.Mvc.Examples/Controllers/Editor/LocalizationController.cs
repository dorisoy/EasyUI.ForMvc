namespace EasyUI.Web.Mvc.Examples
{
    using System.Web;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class EditorController : Controller
    {
        [CultureAwareAction]
        public ActionResult Localization()
        {
            return View();
        }
    }
}