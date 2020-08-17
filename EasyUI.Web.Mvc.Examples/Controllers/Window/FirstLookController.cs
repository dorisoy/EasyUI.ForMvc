namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public partial class WindowController : Controller
    {
        public ActionResult FirstLook(bool? modal, bool? scrolling, bool? animation, bool? resizable, bool? movable)
        {
            ViewData["modal"] = modal ?? false;
            ViewData["scrolling"] = scrolling ?? true;
            ViewData["resizable"] = resizable ?? true;
            ViewData["movable"] = movable ?? true;

            return View();
        }
    }
}