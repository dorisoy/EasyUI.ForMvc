namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class TabStripController : Controller
    {
        [SourceCodeFile("NavigationDataBuilder", "~/Models/NavigationData.cs")]
        public ActionResult DataBindingToModel()
        {
            ViewData.Model = NavigationDataBuilder.GetCollection();

            return View();
        }
    }
}