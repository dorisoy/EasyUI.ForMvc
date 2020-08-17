namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Extensions;
    
    using Models;
    using EasyUI.Web.Mvc.UI;
    using System.Web.Routing;

    public partial class GridController : Controller
    {
        [SourceCodeFile("EditableProduct (model)", "~/Models/EditableProduct.cs")]
        [SourceCodeFile(
            Caption = "Date (editor)",
            FileName = "~/Views/Shared/EditorTemplates/Date.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/Date.ascx")]
        [SourceCodeFile("SessionProductRepository", "~/Models/SessionProductRepository.cs")]
        public ActionResult EditingServerSide(GridEditMode? mode, GridButtonType? type)
        {
            ViewData["mode"] = mode ?? GridEditMode.InLine;
            ViewData["type"] = type ?? GridButtonType.Text;
            return View(SessionProductRepository.All());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Insert(GridEditMode mode, GridButtonType type)
        {
            ViewData["mode"] = mode;
            ViewData["type"] = type;

            //Create a new instance of the EditableProduct class.
            EditableProduct product = new EditableProduct();

            //Perform model binding (fill the product properties and validate it).
            if (TryUpdateModel(product))
            {
                //The model is valid - insert the product and redisplay the grid.
                SessionProductRepository.Insert(product);

                //GridRouteValues() is an extension method which returns the 
                //route values defining the grid state - current page, sort expression, filter etc.
                RouteValueDictionary routeValues = this.GridRouteValues();
                // add the editing mode to the route values
                routeValues.Add("mode", mode);

                return RedirectToAction("EditingServerSide", routeValues);
            }

            //The model is invalid - render the current view to show any validation errors
            return View("EditingServerSide", SessionProductRepository.All());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Save(int id, GridEditMode mode, GridButtonType type)
        {
            ViewData["mode"] = mode;
            ViewData["type"] = type;

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
                // add the editing mode to the route values
                routeValues.Add("mode", mode);

                return RedirectToAction("EditingServerSide", routeValues);
            }

            //The model is invalid - render the current view to show any validation errors
            return View("EditingServerSide", SessionProductRepository.All());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete(int id, GridEditMode mode, GridButtonType type)
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
                // add the editing mode to the route values
                routeValues.Add("mode", mode);
                // add button type to the route values
                routeValues.Add("type", type);

                return RedirectToAction("EditingServerSide", routeValues);
            }
            
            //Delete the record
            SessionProductRepository.Delete(product);

            routeValues = this.GridRouteValues();
            // add the editing mode to the route values
            routeValues.Add("mode", mode);
            // add button type to the route values
            routeValues.Add("type", type);

            //Redisplay the grid
            return RedirectToAction("EditingServerSide", routeValues);
        }
    }
}