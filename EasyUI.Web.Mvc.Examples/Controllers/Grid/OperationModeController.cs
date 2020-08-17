namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using Models;
    using System.Linq;
using EasyUI.Web.Mvc.UI;

    public partial class GridController : Controller
    {
        public ActionResult OperationMode(GridOperationMode? operationMode)
        {
            ViewData["OperationMode"] = operationMode ?? GridOperationMode.Client;
            return View();
        }

        [GridAction]
        public ActionResult _OperationMode()
        {
            return View(new GridModel<OrderDto>
            {
                Data = GetOrderDto()
            });
        }
    }
}