﻿namespace EasyUI.Web.Mvc.Examples.Models
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;

    [KnownType(typeof(OrderDto))]
    public class OrderDto
    {
        [Range(1, 10)]
        public int OrderID
        {
            get;
            set;
        }
        
        public string ContactName
        {
            get;
            set;
        }

        public string ShipAddress
        {
            get;
            set;
        }

        [Required]
        public DateTime? OrderDate
        {
            get;
            set;
        }
    }
}
