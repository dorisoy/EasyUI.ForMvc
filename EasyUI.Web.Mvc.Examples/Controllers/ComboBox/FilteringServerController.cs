namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class ComboBoxController : Controller
    {
        public ActionResult FilteringServer(ComboBoxAjaxFilteringModel model)
        {
            model.ComboBoxAttributes.AutoFill = model.ComboBoxAttributes.AutoFill ?? true;
            model.ComboBoxAttributes.Cache = model.ComboBoxAttributes.Cache ?? true;
            model.ComboBoxAttributes.Delay = model.ComboBoxAttributes.Delay ?? 400;
            model.ComboBoxAttributes.FilterMode = model.ComboBoxAttributes.FilterMode ?? 0;
            model.ComboBoxAttributes.HighlightFirst = model.ComboBoxAttributes.HighlightFirst ?? true;
            model.ComboBoxAttributes.MinimumChars = model.ComboBoxAttributes.MinimumChars ?? 0;

            model.AutoCompleteAttributes.AutoFill = model.AutoCompleteAttributes.AutoFill ?? true;
            model.AutoCompleteAttributes.Cache = model.AutoCompleteAttributes.Cache ?? true;
            model.AutoCompleteAttributes.Delay = model.AutoCompleteAttributes.Delay ?? 400;
            model.AutoCompleteAttributes.FilterMode = model.AutoCompleteAttributes.FilterMode ?? 1;
            model.AutoCompleteAttributes.HighlightFirst = model.AutoCompleteAttributes.HighlightFirst ?? true;
            model.AutoCompleteAttributes.MinimumChars = model.AutoCompleteAttributes.MinimumChars ?? 1;
            model.AutoCompleteAttributes.AllowMultipleValues = model.AutoCompleteAttributes.AllowMultipleValues ?? false;

            return View(model);
        }

        [HttpPost]
        public ActionResult _FilteringAjax(string text, int? filterMode)
        {
            var nw = new NorthwindDataContext();

            IQueryable<Product> products = nw.Products.AsQueryable();

            switch ( filterMode )
            {
                case 1: // StartsWith
                    {
                        products = products.Where((p) => p.ProductName.StartsWith(text));
                        break;
                    }
                case 2: // Contains
                    {
                        products = products.Where((p) => p.ProductName.IndexOf(text) != -1);
                        break;
                    }
                default: // None
                    {
                        break;
                    }
            }

            return new JsonResult { JsonRequestBehavior = JsonRequestBehavior.AllowGet, Data = new SelectList(products.ToList(), "ProductID", "ProductName") };
        }

        [HttpPost]
        public ActionResult _AutoCompleteFilteringAjax(string text, int? filterMode)
        {
            var nw = new NorthwindDataContext();

            IQueryable<Product> products = nw.Products.AsQueryable();

            switch (filterMode)
            {
                case 1: // StartsWith
                    {
                        products = products.Where((p) => p.ProductName.StartsWith(text));
                        break;
                    }
                case 2: // Contains
                    {
                        products = products.Where((p) => p.ProductName.IndexOf(text) != -1);
                        break;
                    }
                default: // None
                    {
                        break;
                    }
            }

            return new JsonResult { Data = products.Select(p => p.ProductName) };
        }
    }

    public class ComboBoxAjaxFilteringModel
    {
        public ComboBoxAjaxFilteringModel()
        {
            ComboBoxAttributes = new AjaxComboBoxAttributes();
            AutoCompleteAttributes = new AjaxAutoCompleteAttributes();
        }

        public AjaxComboBoxAttributes ComboBoxAttributes
        {
            get;
            set;
        }

        public AjaxAutoCompleteAttributes AutoCompleteAttributes
        {
            get;
            set;
        }
    }
}