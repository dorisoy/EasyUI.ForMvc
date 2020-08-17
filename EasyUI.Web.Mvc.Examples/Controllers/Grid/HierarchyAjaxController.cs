namespace EasyUI.Web.Mvc.Examples
{
    using System.Linq;
    using System.Web.Mvc;
    using Models;

    public partial class GridController : Controller
    {
        public ActionResult HierarchyAjax()
        {
            return View();
        }

        [GridAction]
        public ActionResult _EmployeesHierarchyAjax()
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
                                Title = e.Title
                            };
            
            return View(new GridModel(employees));
        }
        
        [GridAction]
        public ActionResult _OrdersForEmployeeHierarchyAjax(int employeeID)
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
        
        [GridAction]
        public ActionResult _OrderDetailsForOrderHierarchyAjax(int orderID)
        {
            var orderDetails = from o in new NorthwindDataContext().Order_Details
                         where o.OrderID == orderID
                         select new OrderDetailsViewModel
                         {
                             Discount = o.Discount,
                             ProductName = o.Product.ProductName,
                             Quantity = o.Quantity,
                             UnitPrice = o.UnitPrice
                         };

            return View(new GridModel(orderDetails));
        }
    }
}