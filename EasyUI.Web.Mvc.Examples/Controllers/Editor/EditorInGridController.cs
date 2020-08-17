namespace EasyUI.Web.Mvc.Examples
{
    using System.Web;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;
    using EasyUI.Web.Mvc.Extensions;

    public partial class EditorController : Controller
    {
        [SourceCodeFile("EditableEmployee (model)", "~/Models/EditableEmployee.cs")]
        [SourceCodeFile(
            FileName = "~/Views/Editor/EditorTemplates/Editor.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Editor/EditorTemplates/Editor.ascx")]
        public ActionResult EditorInGrid()
        {
            return View(SessionEmployeeRepository.All());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UpdateEmployee(int id)
        {
            EditableEmployee employee = SessionEmployeeRepository.One(e => e.EmployeeID == id);

            if (TryUpdateModel(employee))
            {
                // HTML decode the Notes property
                employee.Notes = HttpUtility.HtmlDecode(employee.Notes);
                SessionEmployeeRepository.Update(employee);

                return RedirectToAction("EditorInGrid", this.GridRouteValues());
            }

            return View("EditorInGrid", SessionEmployeeRepository.All());
        }
    }
}