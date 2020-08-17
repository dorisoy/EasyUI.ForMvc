namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;
    using Models;

    using Extensions;
    using System.Threading;

    public partial class ComboBoxController : Controller
    {
        public ActionResult AjaxLoading()
        {
            return View();
        }

        [HttpPost]
        public ActionResult _AjaxLoading(string text)
        {
            Thread.Sleep(1000);

            using ( var nw = new NorthwindDataContext() )
            {
                var products = nw.Products.AsQueryable();

                if ( text.HasValue() )
                {
                     products = products.Where((p) => p.ProductName.StartsWith(text));
                }

                return new JsonResult { Data = new SelectList(products.ToList(), "ProductID", "ProductName") };
            }
        }

        [HttpPost]
        public ActionResult _AutoCompleteAjaxLoading(string text)
        {
            Thread.Sleep(1000);

            using (var nw = new NorthwindDataContext())
            {
                var products = nw.Products.AsQueryable();

                if (text.HasValue())
                {
                    products = products.Where((p) => p.ProductName.StartsWith(text));
                }

                return new JsonResult { Data = products.Select(p => p.ProductName).ToList() };
            }
        }
    }
}