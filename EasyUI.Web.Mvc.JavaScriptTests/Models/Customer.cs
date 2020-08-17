namespace EasyUI.Web.Mvc.JavaScriptTests
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel;
    
    public class Customer
    {
        [Required]
        public string Name { get; set; }
        [DataType(DataType.Date)]
        public DateTime BirthDate { get; set; }
        public bool Active { get; set; }

        [ReadOnly(true)]
        public int ReadOnly
        {
            get;
            set;
        }
        public Gender Gender
        {
            get;
            set;
        }

        [UIHint("int")]
        public int IntegerValue { get; set; }

        [UIHint("Address")]
        public Address Address
        {
            get;
            set;
        }

        public Customer()
        {
            Address = new Address
            {
                Street = "foo"
            };
        }
    }

    public class Address
    {
        public string Street
        {
            get;
            set;
        }
    }

    public enum Gender
    {
        Female,
        Male
    }
}
