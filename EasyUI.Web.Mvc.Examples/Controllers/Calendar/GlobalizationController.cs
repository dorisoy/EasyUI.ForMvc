namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public partial class CalendarController : Controller
    {
        [CultureAwareAction]
        public ActionResult Globalization()
        {
            return View();
        }
    }
}