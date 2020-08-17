namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System;

    public partial class DatePickerController : Controller
    {
        public ActionResult ServerValidation()
        {
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ServerValidation(DateTime? delay, DateTime? deliveryDate, DateTime? orderDateTime)
        {
            // Validation logic
            if (delay == null)
            {
                ModelState.AddModelError("delay", "It is required to select a cake delay time.");
            }

            if (deliveryDate == null)
            {
                ModelState.AddModelError("deliveryDate", "It is required to select a cake delivery date.");
            }

            if (orderDateTime == null)
            {
                ModelState.AddModelError("orderDateTime", "It is required to select a cake order date time.");
            }

            if (ModelState.IsValid)
            {
                ViewData["delay"] = delay;
                ViewData["deliveryDate"] = deliveryDate;
                ViewData["orderDateTime"] = orderDateTime;
            }

            return View();
        }
    }
}