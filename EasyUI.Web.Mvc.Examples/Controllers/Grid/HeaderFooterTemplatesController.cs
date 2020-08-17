namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.Linq;
    using Models;

    public partial class GridController : Controller
    {
        public ActionResult HeaderFooterTemplates(int[] checkedRecords)
        {
            checkedRecords = checkedRecords ?? new int[] { };

            var db = new NorthwindDataContext();
            return View(new AggregatedProductModel
                            {
                                Products = db.Products,
                                TotalPrice = db.Products.Sum(p => p.UnitPrice).Value,
                                SelectedProducts = db.Products.Where(p => checkedRecords.Contains(p.ProductID))
                            });
        }
    }
}