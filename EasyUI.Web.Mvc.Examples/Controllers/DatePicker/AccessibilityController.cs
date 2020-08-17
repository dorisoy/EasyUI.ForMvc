namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Web.Mvc;

    public partial class DatePickerController : Controller
    {
        public ActionResult Accessibility(DateTime? delay, DateTime? deliveryDate, DateTime? orderDateTime)
        {
            ViewData["delay"] = delay;
            ViewData["deliveryDate"] = deliveryDate;
            ViewData["orderDateTime"] = orderDateTime;

            return View();
        }
    }
}