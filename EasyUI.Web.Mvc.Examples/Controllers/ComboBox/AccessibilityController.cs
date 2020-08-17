namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.Linq;
    using EasyUI.Web.Mvc.Examples.Models;
    
    public partial class ComboBoxController : Controller
    {
        public ActionResult Accessibility()
        {
            return View(new NorthwindDataContext().Products.ToList());
        }
    }
}