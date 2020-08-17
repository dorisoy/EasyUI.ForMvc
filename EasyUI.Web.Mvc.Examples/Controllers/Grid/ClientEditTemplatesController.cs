namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;

    using Extensions;

    using Models;

    public partial class GridController
    {
        [SourceCodeFile("ClientEditableOrder (model)", "~/Models/ClientEditableOrder.cs")]
        [SourceCodeFile(
            Caption = "ClientEmployee (Editor)",
            FileName = "~/Views/Grid/EditorTemplates/ClientEmployee.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Grid/EditorTemplates/ClientEmployee.ascx")]
        public ActionResult ClientEditTemplates()
        {
            PopulateEmployees();
            
            return View();
        }

        [GridAction]
        public ActionResult _ClientEditTemplate()
        {
            PopulateEmployees();

            return View(new GridModel(SessionClientOrderRepository.All()));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [CultureAwareAction]
        [GridAction]
        public ActionResult _UpdateOrder(int id, int Employee)
        {
            ClientEditableOrder order = new ClientEditableOrder
            {
                OrderID = id,
                Employee = new NorthwindDataContext().Employees.Where(e => e.EmployeeID == Employee).Select(e => e.FirstName + " " + e.LastName).SingleOrDefault()  
            };

            // Exclude "Employee" from the list of updated properties
            if (TryUpdateModel(order, null, null, new[] { "Employee" }))
            {
                SessionClientOrderRepository.Update(order);
            }

            PopulateEmployees();

            return View(new GridModel(SessionClientOrderRepository.All()));
        }
    }
}