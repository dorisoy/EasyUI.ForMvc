namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public partial class SplitterController : Controller
    {
        public ActionResult AjaxLoading()
        {
            return View();
        }

        public ActionResult AjaxView_PanelBar()
        {
            return PartialView();
        }

        public ActionResult AjaxView_Grid()
        {
            return PartialView();
        }
    }
}