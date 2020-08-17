namespace EasyUI.Web.Mvc.Examples.Models
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    public static class SessionEmployeeRepository
    {
        public static IList<EditableEmployee> All()
        {
            IList<EditableEmployee> result = ( IList<EditableEmployee> )HttpContext.Current.Session[ "Employees" ];

            if ( result == null )
            {
                HttpContext.Current.Session[ "Employees" ] = result =
                    ( from employee in new NorthwindDataContext().Employees
                      select new EditableEmployee
                      {
                          EmployeeID = employee.EmployeeID,
                          LastName = employee.LastName,
                          FirstName = employee.FirstName,
                          Notes = employee.Notes,
                      } ).ToList();
            }

            return result;
        }

        public static EditableEmployee One(Func<EditableEmployee, bool> predicate)
        {
            return All().Where(predicate).FirstOrDefault();
        }

        public static void Update(EditableEmployee employee)
        {            
            EditableEmployee target = One(e => e.EmployeeID == employee.EmployeeID);
            if ( target != null )
            {
                target.LastName = employee.LastName;
                target.FirstName = employee.FirstName;
                target.Notes = employee.Notes;
            }
        }
    }
}