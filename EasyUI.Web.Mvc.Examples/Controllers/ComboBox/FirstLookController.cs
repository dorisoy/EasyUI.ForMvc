namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.Linq;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Examples.Models;
    
    public partial class ComboBoxController : Controller
    {
        public ActionResult FirstLook(ComboBoxFirstLookModel model)
        {
            model.AutoCompleteAttributes.Width = model.AutoCompleteAttributes.Width ?? 200;
            model.AutoCompleteAttributes.HighlightFirst = model.AutoCompleteAttributes.HighlightFirst ?? true;
            model.AutoCompleteAttributes.AutoFill = model.AutoCompleteAttributes.AutoFill ?? false;
            model.AutoCompleteAttributes.AllowMultipleValues = model.AutoCompleteAttributes.AllowMultipleValues ?? true;
            model.AutoCompleteAttributes.MultipleSeparator = model.AutoCompleteAttributes.MultipleSeparator ?? ", ";

            model.ComboBoxAttributes.Width = model.ComboBoxAttributes.Width ?? 200;
            model.ComboBoxAttributes.SelectedIndex = model.ComboBoxAttributes.SelectedIndex ?? 0;
            model.ComboBoxAttributes.HighlightFirst = model.ComboBoxAttributes.HighlightFirst ?? true;
            model.ComboBoxAttributes.AutoFill = model.ComboBoxAttributes.AutoFill ?? true;
            model.ComboBoxAttributes.OpenOnFocus = model.ComboBoxAttributes.OpenOnFocus ?? false;

            model.DropDownListAttributes.Width = model.DropDownListAttributes.Width ?? 200;
            model.DropDownListAttributes.SelectedIndex = model.DropDownListAttributes.SelectedIndex ?? 0;

            var nw = new EasyUI.Web.Mvc.Examples.Models.NorthwindDataContext();
            model.Products = nw.Products.ToList();

            return View(model);
        }
    }

    public class ComboBoxFirstLookModel
    {
        public ComboBoxFirstLookModel()
        {
            Products = new List<Product>();
            ComboBoxAttributes = new ComboBoxAttributes();
            DropDownListAttributes = new DropDownListAttributes();
            AutoCompleteAttributes = new AutoCompleteAttributes();
        }

        public IEnumerable<Product> Products
        {
            get;
            set;
        }

        public AutoCompleteAttributes AutoCompleteAttributes
        {
            get;
            set;
        }

        public ComboBoxAttributes ComboBoxAttributes
        {
            get;
            set;
        }

        public DropDownListAttributes DropDownListAttributes
        {
            get;
            set;
        }
    }
}