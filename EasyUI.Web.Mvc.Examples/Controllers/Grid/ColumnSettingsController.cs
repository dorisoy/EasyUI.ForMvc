namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.Web.Routing;
    using EasyUI.Web.Mvc.Examples.Models;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.UI;

    public partial class GridController : Controller
    {
        [SourceCodeFile("EditableProduct (model)", "~/Models/EditableProduct.cs")]
        [SourceCodeFile("SessionProductRepository", "~/Models/SessionProductRepository.cs")]
        public ActionResult ColumnSettings()
        {
            var columns = new[] 
            {
                new GridColumnSettings
                {
                    Member = "ProductName",
                    Width = "200px"
                },
                new GridColumnSettings
                {
                    Member = "UnitPrice",
                    Width = "130px",
                    Format = "{0:c}",
                },
                new GridColumnSettings
                {
                    Member = "UnitsInStock",
                    Width = "130px"
                },
                new GridColumnSettings
                {
                    Member = "LastSupply",
                    Width = "130px",
                    Format = "{0:d}"
                },
                new GridColumnSettings
                {
                    Member = "Discontinued"
                },

                new GridCommandColumnSettings
                {
                    Commands = 
                    {
                        new GridEditActionCommand(),
                        new GridDeleteActionCommand()
                    },
                    Width = "200px",
                    Title = "Commands"
                }
            };

            ViewData["Columns"] = columns;

            return View(SessionProductRepository.All());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ColumnSettings_Save(int id)
        {
            //Create a new instance of the EditableProduct class and set its ProductID property.
            EditableProduct product = new EditableProduct
            {
                ProductID = id
            };

            //Perform model binding (fill the product properties and validate it).
            if (TryUpdateModel(product))
            {
                //The model is valid - update the product and redisplay the grid.
                SessionProductRepository.Update(product);

                //GridRouteValues() is an extension method which returns the 
                //route values defining the grid state - current page, sort expression, filter etc.
                RouteValueDictionary routeValues = this.GridRouteValues();

                return RedirectToAction("ColumnSettings", routeValues);
            }

            //The model is invalid - render the current view to show any validation errors
            return View("ColumnSettings", SessionProductRepository.All());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ColumnSettings_Delete(int id)
        {
            //Find a product with ProductID equal to the id action parameter
            EditableProduct product = SessionProductRepository.One(p => p.ProductID == id);

            RouteValueDictionary routeValues;

            if (product == null)
            {
                //A product with the specified id does not exist - redisplay the grid

                //GridRouteValues() is an extension method which returns the 
                //route values defining the grid state - current page, sort expression, filter etc.
                routeValues = this.GridRouteValues();

                return RedirectToAction("ColumnSettings", routeValues);
            }

            //Delete the record
            SessionProductRepository.Delete(product);

            routeValues = this.GridRouteValues();

            //Redisplay the grid
            return RedirectToAction("ColumnSettings", routeValues);
        }
    }
}