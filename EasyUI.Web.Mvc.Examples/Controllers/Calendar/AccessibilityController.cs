namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Web.Mvc;

    public partial class CalendarController : Controller
    {
        public ActionResult Accessibility(DateTime? date)
        {
            ViewData["date"] = date ?? DateTime.Now;

            return View();
        }
    }
}