namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;
    using Models;
    using EasyUI.Web.Mvc.Extensions;
    using System.Collections;

    public partial class GridController : Controller
    {
        public ActionResult DetailsAjax()
        {
            return View();
        }

        [GridAction]
        public ActionResult _EmployeesDetailsAjax()
        {
            var employees = from e in new NorthwindDataContext().Employees
                            orderby e.EmployeeID
                            select new EmployeeViewModel
                            {
                                EmployeeID = e.EmployeeID,
                                City = e.City,
                                Country = e.Country,
                                FirstName = e.FirstName,
                                LastName = e.LastName,
                                Title = e.Title,
                                HomePhone = e.HomePhone,
                                BirthDate = e.BirthDate,
                                Address = e.Address
                            };

            return View(new GridModel(employees));
        }
        
        [GridAction]
        public ActionResult _OrdersForEmployeeDetailsAjax(int employeeID)
        {
            var orders = from o in new NorthwindDataContext().Orders
                            where o.EmployeeID == employeeID
                            select new OrderViewModel
                            {
                                OrderID = o.OrderID,
                                ShipAddress = o.ShipAddress,
                                ShipCountry = o.ShipCountry,
                                ShipName = o.ShipName,
                                ShippedDate = o.ShippedDate
                            };

            return View(new GridModel(orders));
        }
        
    }
}