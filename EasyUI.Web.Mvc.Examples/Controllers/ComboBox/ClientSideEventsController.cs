namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;

    public partial class ComboBoxController : Controller
    {
        public ActionResult ClientSideEvents()
        {
            using (var nw = new EasyUI.Web.Mvc.Examples.Models.NorthwindDataContext())
            {
                return View(nw.Products.ToList());
            }
        }
    }
}