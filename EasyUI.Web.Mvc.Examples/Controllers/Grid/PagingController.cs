namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;
    using EasyUI.Web.Mvc.UI;

    public partial class GridController : Controller
    {
        public ActionResult Paging(bool? pageInput, bool? nextPrevious, bool? numeric, GridPagerPosition? position, int? currentPage, bool? pageSize)
        {
            ViewData["pageInput"] = pageInput ?? false;
            ViewData["nextPrevious"] = nextPrevious ?? true;
            ViewData["numeric"] = numeric ?? true;
            ViewData["pageSize"] = pageSize ?? false;
            ViewData["position"] = position ?? GridPagerPosition.Bottom;
            ViewData["currentPage"] = currentPage ?? 1;

            return View(GetOrders());
        }

        [GridAction]
        public ActionResult _Paging()
        {
            return View(new GridModel<Order>
            {
                Data = GetOrders()
            });
        }
    }
}