namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;
    using System.Collections.Generic;
    
    using EasyUI.Web.Mvc.Examples.Models;
    
    public partial class ComboBoxController : Controller
    {
        public ActionResult FilteringClient(ComboBoxFilteringModel model)
        {
            model.ComboBoxAttributes.FilterMode = model.ComboBoxAttributes.FilterMode ?? 0;
            model.ComboBoxAttributes.MinimumChars = model.ComboBoxAttributes.MinimumChars ?? 0;
            model.ComboBoxAttributes.HighlightFirst = model.ComboBoxAttributes.HighlightFirst ?? true;
            model.ComboBoxAttributes.AutoFill = model.ComboBoxAttributes.AutoFill ?? true;

            model.AutoCompleteAttributes.FilterMode = model.AutoCompleteAttributes.FilterMode ?? 1;
            model.AutoCompleteAttributes.MinimumChars = model.AutoCompleteAttributes.MinimumChars ?? 1;
            model.AutoCompleteAttributes.HighlightFirst = model.AutoCompleteAttributes.HighlightFirst ?? true;
            model.AutoCompleteAttributes.AutoFill = model.AutoCompleteAttributes.AutoFill ?? true;
            model.AutoCompleteAttributes.AllowMultipleValues = model.AutoCompleteAttributes.AllowMultipleValues ?? false;

            model.Products = new NorthwindDataContext().Products.ToList();

            return View(model);
        }
    }

    public class ComboBoxFilteringModel
    {
        public ComboBoxFilteringModel()
        {
            Products = new List<Product>();
            ComboBoxAttributes = new ComboBoxAttributes();
            AutoCompleteAttributes = new AutoCompleteAttributes();
        }

        public IEnumerable<Product> Products
        {
            get;
            set;
        }

        public ComboBoxAttributes ComboBoxAttributes
        {
            get;
            set;
        }

        public AutoCompleteAttributes AutoCompleteAttributes
        {
            get;
            set;
        }
    }
}