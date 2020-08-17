namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.Linq;
    using Extensions;
    using Models;
    using System.Collections.Generic;

    public partial class GridController : Controller
    {
        public ActionResult CustomToolBar()
        {
            return View(GetOrders());
        }

        [GridAction]
        public ActionResult _CustomToolBar(string customerID)
        {
            IEnumerable<Order> orders;
            orders = customerID.HasValue() ? GetOrdersForCustomer(customerID) : GetOrders();
            return View(new GridModel(orders));
        }

        [HttpPost]
        public ActionResult _GetCustomers(string text)
        {
            using (var db = new NorthwindDataContext())
            {
                IQueryable<Customer> result = db.Customers;
                if (text.HasValue())
                {
                    result = db.Customers.Where(c => c.ContactName.StartsWith(text));
                }
                return new JsonResult
                           {
                               Data = new SelectList(result.ToList(), "CustomerID", "ContactName")
                           };
            }
        }
    }
}