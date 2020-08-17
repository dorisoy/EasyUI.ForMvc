namespace EasyUI.Web.Mvc.Examples
{
    using System.Collections.Generic;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class GridController : Controller
    {
        [SourceCodeFile("EditableProduct", "~/Models/EditableProduct.cs", Order = 1)]
        [SourceCodeFile("SessionProductRepository", "~/Models/SessionProductRepository.cs", Order = 2)]
        [SourceCodeFile(
            Caption = "Currency (editor)",
            FileName = "~/Views/Shared/EditorTemplates/Currency.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/Currency.ascx",
            Order = 3)]
        [SourceCodeFile(
            Caption = "Number (editor)",
            FileName = "~/Views/Shared/EditorTemplates/Number.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/Number.ascx",
            Order = 4)]
        [SourceCodeFile(
            Caption = "Date (editor)",
            FileName = "~/Views/Shared/EditorTemplates/Date.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/Date.ascx",
            Order = 5)]
        public ActionResult KeyboardNavigation()
        {            
            return View();
        }

        [GridAction]
        public ActionResult _SelectAjax()
        {
            return View(new GridModel(SessionProductRepository.All()));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [CultureAwareAction]
        [GridAction]
        public ActionResult _SaveAjax([Bind(Prefix = "inserted")]IEnumerable<EditableProduct> insertedProducts,
            [Bind(Prefix = "updated")]IEnumerable<EditableProduct> updatedProducts,
            [Bind(Prefix = "deleted")]IEnumerable<EditableProduct> deletedProducts)
        {
            if (insertedProducts != null)
            {
                foreach (var product in insertedProducts)
                {
                    SessionProductRepository.Insert(product);
                }
            }

            if (updatedProducts != null)
            {
                foreach (var product in updatedProducts)
                {
                    var target = SessionProductRepository.One(p => p.ProductID == product.ProductID);
                    if (target != null)
                    {
                        target.ProductName = product.ProductName;
                        target.UnitPrice = product.UnitPrice;
                        target.UnitsInStock = product.UnitsInStock;
                        target.LastSupply = product.LastSupply;
                        target.Discontinued = product.Discontinued;

                        SessionProductRepository.Update(target);
                    }
                }
            }

            if (deletedProducts != null)
            {
                foreach (var product in deletedProducts)
                {
                    SessionProductRepository.Delete(product);
                }
            }

            return View(new GridModel(SessionProductRepository.All()));
        }
       
    }
}
