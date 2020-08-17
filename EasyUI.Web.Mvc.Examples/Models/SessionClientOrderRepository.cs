using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EasyUI.Web.Mvc.Examples.Models
{
    public static class SessionClientOrderRepository
    {
        public static IEnumerable<ClientEditableOrder> All()
        {
            IEnumerable<ClientEditableOrder> result = HttpContext.Current.Session["clietOrders"] as IEnumerable<ClientEditableOrder>;

            if (result == null)
            {
                HttpContext.Current.Session["clietOrders"] = result = new NorthwindDataContext().Orders.Select(o => new ClientEditableOrder { OrderID = o.OrderID, OrderDate = o.OrderDate ?? DateTime.Now, EmployeeID = o.EmployeeID, Employee = o.Employee.FirstName + " " + o.Employee.LastName, Freight = o.Freight ?? 0 }).ToList();
            }

            return result;
        }

        public static ClientEditableOrder One(Func<ClientEditableOrder, bool> predicate)
        {
            return All().Where(predicate).FirstOrDefault();
        }

        public static void Update(ClientEditableOrder order)
        {
            ClientEditableOrder editable = One(o => o.OrderID == order.OrderID);

            if (editable != null)
            {
                editable.OrderDate = order.OrderDate;
                editable.Employee = order.Employee;
                editable.Freight = order.Freight;
                editable.EmployeeID = order.EmployeeID;
            }
        }
    }
}