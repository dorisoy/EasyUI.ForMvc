namespace EasyUI.Web.Mvc.Examples.Models
{
    using System.Runtime.Serialization;
    using System.ComponentModel.DataAnnotations;
    using System.Web.Mvc;

    [KnownType(typeof(EmployeeDto))]
    public class EmployeeDto
    {
        public int EmployeeID 
        { 
            get; 
            set; 
        }

        [Required]
        public string FirstName
        {
            get;
            set;
        }

        [Required]
        public string LastName
        {
            get;
            set;
        }
        
        [Required]
        [AllowHtml]
        public string Notes
        {
            get;
            set;
        }
    }
}