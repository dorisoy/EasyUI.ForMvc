namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;

    public partial class GridController : Controller
    {
        public ActionResult CustomColumnCommand()
        {
            return View(GetOrders());
        }

        public JsonResult ViewDetails(int orderID)
        {
            var order = GetOrders()
                            .FirstOrDefault(o => o.OrderID == orderID);

            return Json(new { customer = order.Customer });
        }
    }
}