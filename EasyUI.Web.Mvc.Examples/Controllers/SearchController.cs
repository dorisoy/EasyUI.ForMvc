namespace EasyUI.Web.Mvc.Examples.Controllers
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;
    
    public class SearchController : Controller
    {
        public ActionResult Search()
        {
            return View();
        }

        [HttpPost]
        public ActionResult _Search(string text)
        {
            var result = ExampleRepository.Filter(text);

            return new JsonResult { Data = new SelectList(result, "Url", "Text") };
        }
    }
}