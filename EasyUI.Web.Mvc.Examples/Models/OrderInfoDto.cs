namespace EasyUI.Web.Mvc.Examples.Models
{
    using System;
    using System.ComponentModel;
    using System.ComponentModel.DataAnnotations;

    public class OrderInfoDto
    {
        [ScaffoldColumn(false)]
        public int OrderInfoID
        {
            get;
            set;
        }

        [DisplayName("Delay")]
        [DataType(DataType.Time)]
        [Required]
        public DateTime? Delay
        {
            get;
            set;
        }

        [DisplayName("Delivery date")]
        [DataType(DataType.Date)]
        [Required]
        public DateTime? DeliveryDate
        {
            get;
            set;
        }

        [DisplayName("Order date time")]
        [DataType(DataType.DateTime)]
        [Required]
        public DateTime? OrderDateTime
        {
            get;
            set;
        }
    }
}