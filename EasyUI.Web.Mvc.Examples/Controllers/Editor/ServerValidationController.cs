namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class EditorController : Controller
    {
        [SourceCodeFile("EmployeeDto (model)", "~/Models/EmployeeDto.cs")]
        public ActionResult ServerValidation()
        {
            var employee = new EmployeeDto
               {
                   FirstName = "Nancy",
                   LastName = "Davolio",
                   Notes = ""
               };

            return View(employee);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [SourceCodeFile("EmployeeDto (model)", "~/Models/EmployeeDto.cs")]
        public ActionResult ServerValidation(EmployeeDto employeeDto)
        {
            if (ModelState.IsValid)
            {
                ViewData["FirstName"] = employeeDto.FirstName;
                ViewData["LastName"] = employeeDto.LastName;
                ViewData["Notes"] = employeeDto.Notes;
            }

            return View();
        }
    }
}