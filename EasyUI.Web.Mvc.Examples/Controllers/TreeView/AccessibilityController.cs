namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public partial class TreeViewController : Controller
    {
        public ActionResult Accessibility(string employeeName)
        {
            ViewData["employeeName"] = employeeName;
            return View(GetRootEmployees());
        }
    }
}