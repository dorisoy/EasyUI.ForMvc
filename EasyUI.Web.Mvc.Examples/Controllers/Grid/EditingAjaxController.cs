namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;
    
    using Models;
    using System;
    using EasyUI.Web.Mvc.UI;

    public partial class GridController : Controller
    {
        [SourceCodeFile("EditableProduct (model)", "~/Models/EditableProduct.cs")]
        [SourceCodeFile("SessionProductRepository", "~/Models/SessionProductRepository.cs")]
        [SourceCodeFile("Date.ascx (editor)", "~/Views/Shared/EditorTemplates/Date.ascx")]
        public ActionResult EditingAjax(GridEditMode? mode, GridButtonType? type)
        {
            ViewData["mode"] = mode ?? GridEditMode.InLine;
            ViewData["type"] = type ?? GridButtonType.Text;
            return View();
        }

        [GridAction]
        public ActionResult _SelectAjaxEditing()
        {
            return View(new GridModel(SessionProductRepository.All()));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [CultureAwareAction]
        [GridAction]
        public ActionResult _SaveAjaxEditing(int id)
        {
            EditableProduct product = SessionProductRepository.One(p => p.ProductID == id);
            
            TryUpdateModel(product);

            SessionProductRepository.Update(product);

            return View(new GridModel(SessionProductRepository.All()));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [CultureAwareAction]
        [GridAction]
        public ActionResult _InsertAjaxEditing()
        {
            //Create a new instance of the EditableProduct class.
            EditableProduct product = new EditableProduct();

            //Perform model binding (fill the product properties and validate it).
            if (TryUpdateModel(product))
            {
                //The model is valid - insert the product.
                SessionProductRepository.Insert(product);
            }

            //Rebind the grid
            return View(new GridModel(SessionProductRepository.All()));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [GridAction]
        public ActionResult _DeleteAjaxEditing(int id)
        {
            //Find a customer with ProductID equal to the id action parameter
            EditableProduct product = SessionProductRepository.One(p => p.ProductID == id);

            if (product != null)
            {
                //Delete the record
                SessionProductRepository.Delete(product);
            }
            
            //Rebind the grid
            return View(new GridModel(SessionProductRepository.All()));
        }
    }
}
