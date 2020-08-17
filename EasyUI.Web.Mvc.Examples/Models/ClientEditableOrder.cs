namespace EasyUI.Web.Mvc.Examples.Models
{
    using System;
    using System.ComponentModel;
    using System.ComponentModel.DataAnnotations;

    public class ClientEditableOrder
    {
        [ReadOnly(true)]
        public int OrderID { get; set; }

        [UIHint("ClientEmployee"), Required]
        public string Employee { get; set; }
        
        public int? EmployeeID { get; set; }

        [DataType(DataType.Date), Required]
        public DateTime OrderDate { get; set; }

        [DataType(DataType.Currency), Required]
        public decimal Freight { get; set; }
    }
}