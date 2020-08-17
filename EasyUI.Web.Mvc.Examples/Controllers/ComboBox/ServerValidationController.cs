namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;
    
    public partial class ComboBoxController : Controller
    {
        [SourceCodeFile("_AjaxLoading (Action method)", "~/Controllers/ComboBox/AjaxLoadingController.cs")]
        public ActionResult ServerValidation()
        {
            ProductDto dto =
                new ProductDto
                {
                    ProductID = 1,
                    UnitPrice = 12
                };

            return View(dto);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ServerValidation(ProductDto dto)
        {
            if (ModelState.IsValid)
            {
                ViewData["productID"] = dto.ProductID;
            }

            return View(dto);
        }
    }
}