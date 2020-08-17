namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;

    public partial class ComboBoxController : Controller
    {
        public ActionResult AnimationEffects(
               string animation,
               int? openDuration,
               int? closeDuration)
        {
            ViewData[ "animation" ] = animation ?? "slide";
            ViewData[ "openDuration" ] = openDuration ?? 200;
            ViewData[ "closeDuration" ] = closeDuration ?? 200;

            using ( var nw = new EasyUI.Web.Mvc.Examples.Models.NorthwindDataContext() )
            {
                return View(nw.Products.ToList());
            }
        }
    }
}