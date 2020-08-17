namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;
    using Models;

    public partial class GridController
    {
        public ActionResult ForeignKeyColumn()
        {
            PopulateEmployees();
            
            return View();
        }

        [GridAction]
        public ActionResult _ForeignKeyColumn()
        {            
            return View(new GridModel(SessionClientOrderRepository.All()));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [CultureAwareAction]
        [GridAction]
        public ActionResult _ForeignKeyColumnUpdateOrder(int id, int employeeId)
        {
            var order = new ClientEditableOrder
            {
                OrderID = id,
                Employee = new NorthwindDataContext().Employees
                        .Where(e => e.EmployeeID == employeeId)
                        .Select(e => e.FirstName + " " + e.LastName).SingleOrDefault()
            };

            // Exclude "Employee" from the list of updated properties
            if (TryUpdateModel(order, null, null, new[] { "Employee" }))
            {
                SessionClientOrderRepository.Update(order);
            }            

            return View(new GridModel(SessionClientOrderRepository.All()));
        }
    }
}