namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.Linq;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Examples.Models;
    
    public partial class ComboBoxController : Controller
    {
        public ActionResult RtlSupport()
        {
            var nw = new EasyUI.Web.Mvc.Examples.Models.NorthwindDataContext();

            return View(nw.Products);
        }
    }
}