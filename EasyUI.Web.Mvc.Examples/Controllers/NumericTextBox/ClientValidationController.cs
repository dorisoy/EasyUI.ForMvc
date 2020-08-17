namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class NumericTextBoxController : Controller
    {
        public ActionResult ClientValidation()
        {
            OrderDto dto =
                new OrderDto
                {
                    OrderID = 30,
                    ContactName = "Vincent",
                    OrderDate = null,
                    ShipAddress = "Stadhouderskade 55,\n1072 AB Amsterdam"
                };

            return View(dto);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ClientValidation(OrderDto dto)
        {
            return View(dto);
        }
    }
}