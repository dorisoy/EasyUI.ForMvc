namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.Web;

    public partial class WindowController : Controller
    {
        public ActionResult PopupForm()
        {
            return View();
        }

        [HttpPost]
        public ActionResult PopupForm(string name, string email, string comment)
        {
            ViewData["name"] = name;
            ViewData["email"] = email;
            ViewData["comment"] = HttpUtility.HtmlDecode(comment);

            return View();
        }
    }
}