namespace EasyUI.Web.Mvc.Examples.Models
{
    using System.ComponentModel.DataAnnotations;

    public class ProductDto
    {
        [Required(ErrorMessage="The Product Name field is required.")]
        public int ProductID
        {
            get;
            set;
        }

        public string ProductName
        {
            get;
            set;
        }

        [UIHint("Slider")]
        public decimal UnitPrice
        {
            get;
            set;
        }
    }
}