namespace EasyUI.Web.Mvc.Examples.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel;

    public class EditableEmployee
    {
        [ReadOnly(true)]
        public int EmployeeID
        {
            get;
            set;
        }

        [DataType(DataType.Text), Required]
        public string LastName
        {
            get;
            set;
        }

        [DataType(DataType.Text), Required]
        public string FirstName
        {
            get;
            set;
        }

        [UIHint("Editor"), Required]
        public string Notes
        {
            get;
            set;
        }
    }
}