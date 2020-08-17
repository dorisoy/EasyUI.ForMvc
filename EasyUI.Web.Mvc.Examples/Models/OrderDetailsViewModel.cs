using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EasyUI.Web.Mvc.Examples.Models
{
    public class OrderDetailsViewModel
    {
        public string ProductName
        {
            get;
            set;
        }

        public short Quantity
        {
            get;
            set;
        }

        public decimal UnitPrice
        {
            get;
            set;
        }

        public float Discount
        {
            get;
            set;
        }
    }
}