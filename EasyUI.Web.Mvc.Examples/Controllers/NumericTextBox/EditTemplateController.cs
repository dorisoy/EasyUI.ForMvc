namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class NumericTextBoxController : Controller
    {
        [SourceCodeFile(
            FileName = "~/Views/Shared/EditorTemplates/Currency.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/Currency.ascx")]
        [SourceCodeFile(
            FileName = "~/Views/Shared/EditorTemplates/Integer.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/Integer.ascx")]
        [SourceCodeFile("EditableProduct.cs", "~/Models/EditableProduct.cs")]
        public ActionResult EditTemplate(EditableProduct product)
        {
            if (product.ProductID == 0)
            {
                product.ProductID = 1;
                product.ProductName = "Chai";
                product.UnitsInStock = 39;
                product.UnitPrice = 18.00m;
                product.LastSupply = DateTime.Today;
            }
            else 
            {
                ViewData["product"] = product;
            }

            return View(product);
        }
    }
}