namespace EasyUI.Web.Mvc.Examples.Models
{
    using System.Collections.Generic;

    public class AggregatedProductModel
    {
        public IEnumerable<Product> Products { get; set; }
        public decimal TotalPrice { get; set; }
        public IEnumerable<Product> SelectedProducts { get; set; }
    }
}