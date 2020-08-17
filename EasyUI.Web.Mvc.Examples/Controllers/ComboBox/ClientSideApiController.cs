namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;

    public partial class ComboBoxController : Controller
    {
        public ActionResult ClientSideApi()
        {
            using ( var nw = new EasyUI.Web.Mvc.Examples.Models.NorthwindDataContext() ) //extract it as general method in common ComboBox partial class
            {
                return View(nw.Products.ToList());
            }
        }
    }
}