namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class ChartController
    {
        [SourceCodeFile("Model", "~/Models/SalesData.cs")]
        public ActionResult AjaxBinding()
        {
            return View();
        }

        public ActionResult _SalesData()
        {
            return Json(SalesDataBuilder.GetCollection());
        }
    }
}