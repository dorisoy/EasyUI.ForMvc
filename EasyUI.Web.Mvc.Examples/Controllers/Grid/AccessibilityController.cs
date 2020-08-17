namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public partial class GridController : Controller
    {
        public ActionResult Accessibility()
        {
            return View(GetOrders());
        }
    }
}