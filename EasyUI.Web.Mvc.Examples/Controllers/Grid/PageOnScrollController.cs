namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;
    using EasyUI.Web.Mvc.UI;

    public partial class GridController : Controller
    {        
        [GridAction]
        public ActionResult _PageOnScroll()
        {
            return View(new GridModel<Order>
            {
                Data = GetOrders()
            });
        }

        public ActionResult PageOnScroll()
        {           
            return View(GetOrders());
        }
    }
}