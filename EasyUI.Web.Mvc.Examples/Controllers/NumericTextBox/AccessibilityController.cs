namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public partial class NumericTextBoxController : Controller
    {
        public ActionResult Accessibility(double? numericTextBox)
        {
            ViewData["value"] = numericTextBox;

            return View();
        }
    }
}