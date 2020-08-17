namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.UI;

    public partial class GridController : Controller
    {
        [SourceCodeFile("EditableProduct (model)", "~/Models/EditableProduct.cs")]
        [SourceCodeFile(
            Caption = "Date (editor)",
            FileName = "~/Views/Shared/EditorTemplates/Date.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/Date.ascx")]
        [SourceCodeFile("WCF", "~/Models/Products.svc.cs")]
        public ActionResult EditingWebService(GridEditMode? mode, GridButtonType? type)
        {
            ViewData["mode"] = mode ?? GridEditMode.InLine;
            ViewData["type"] = type ?? GridButtonType.Text;
            return View();
        }
    }
}
