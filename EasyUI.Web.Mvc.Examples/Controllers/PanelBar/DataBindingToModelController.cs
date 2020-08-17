namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class PanelBarController : Controller
    {
        public ActionResult DataBindingToModel()
        {
            NorthwindDataContext northwind = new NorthwindDataContext();
            return View(northwind.Categories);
        }
    }
}