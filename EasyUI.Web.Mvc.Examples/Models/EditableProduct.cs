﻿namespace EasyUI.Web.Mvc.Examples.Models
{
    using System;
    using System.ComponentModel;
    using System.ComponentModel.DataAnnotations;

    using System.Runtime.Serialization;

    [KnownType(typeof(EditableProduct))]
    public class EditableProduct
    {
        [ScaffoldColumn(false)]
        public int ProductID
        {
            get;
            set;
        }

        [Required]
        [DisplayName("Product name")]
        public string ProductName
        {
            get;
            set;
        }

        [Required]
        [DisplayName("Unit price")]
        [DataType(DataType.Currency)]
        public decimal UnitPrice
        {
            get;
            set;
        }

        [Required]
        [DisplayName("Units in stock")]
        [DataType("Integer")]
        public int UnitsInStock
        {
            get;
            set;
        }

        public bool Discontinued
        {
            get;
            set;
        }

        [DisplayName("Last supply")]
        [DataType(DataType.Date)]
        public DateTime LastSupply
        {
            get;
            set;
        }
    }
}