using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EasyUI.Web.Mvc.Examples.Models
{
    public class EmployeeViewModel
    {
        public string FirstName
        {
            get;
            set;
        }

        public int EmployeeID
        {
            get;
            set;
        }

        public string LastName
        {
            get;
            set;
        }
        
        public string Title
        {
            get;
            set;
        }
        
        public string Country
        {
            get;
            set;
        }
        
        public string City
        {
            get;
            set;
        }

        public string HomePhone 
        { 
            get; 
            set; 
        }

        public DateTime? BirthDate
        {
            get;
            set;
        }

        public string Address
        {
            get;
            set;
        }
    }
}