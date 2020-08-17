namespace EasyUI.Web.Mvc.Examples.Models
{
    using System;
    using System.ComponentModel;
    using System.ComponentModel.DataAnnotations;
    using System.Runtime.Serialization;

    [KnownType(typeof(EditableCustomer))]
    public class EditableCustomer
    {
        [Required]
        [DisplayName("Name")]
        public string ContactName
        {
            get;
            set;
        }

        [Required]
        public string Address
        {
            get;
            set;
        }

        [ScaffoldColumn(false)]
        public string CustomerID
        {
            get;
            set;
        }

        [Required]
        public string Country
        {
            get;
            set;
        }

        [Required]
        [DisplayName("Company")]
        public string CompanyName
        {
            get;
            set;
        }

        [Required]
        public string Phone
        {
            get;
            set;
        }

        [DisplayName("Birthday")]
        [DataType(DataType.Date)]
        public DateTime BirthDay
        {
            get;
            set;
        }
    }
}