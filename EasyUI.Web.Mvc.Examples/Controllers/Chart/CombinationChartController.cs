namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class ChartController
    {
        [SourceCodeFile("Model", "~/Models/SalesData.cs")]
        public ActionResult CombinationChart()
        {
            return View(SalesDataBuilder.GetCollection());
        }
    }
}