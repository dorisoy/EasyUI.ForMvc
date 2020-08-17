namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.Linq;

    public partial class GridController : Controller
    {
        [SourceCodeFile(
            Caption = "CheckedOrders",
            FileName = "~/Views/Grid/CheckedOrders.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Grid/CheckedOrders.ascx")]
        public ActionResult CheckBoxesAjax()
        {
            return View();
        }

        [GridAction]
        public ActionResult _CheckBoxesAjax()
        {
            return View(new GridModel(GetOrders()));
        }

        public ActionResult DisplayCheckedOrders(int[] checkedRecords)
        {
            checkedRecords = checkedRecords ?? new int[]{};
            return PartialView("CheckedOrders", GetOrders().Where(o => checkedRecords.Contains(o.OrderID)));
        }
    }
}