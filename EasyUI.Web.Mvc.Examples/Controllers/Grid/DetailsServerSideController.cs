namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;
    using Models;

    public partial class GridController : Controller
    {
        public ActionResult DetailsServerSide()
        {
            return View(new NorthwindDataContext().Employees);
        }
    }
}