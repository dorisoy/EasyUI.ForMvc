namespace EasyUI.Web.Mvc.Examples
{
    using System.Collections.Generic;
    using System.IO;
    using System.Web;
    using System.Web.Mvc;

    public partial class UploadController : Controller
    {
        public ActionResult FirstLook(bool? autoUpload, bool? multiple)
        {
            ViewData["autoUpload"] = autoUpload ?? true;
            ViewData["multiple"] = multiple ?? true;

            return View();
        }

        public ActionResult Save(IEnumerable<HttpPostedFileBase> attachments)
        {
            // The Name of the Upload component is "attachments" 
            foreach (var file in attachments)
            {
                // Some browsers send file names with full path. This needs to be stripped.
                var fileName = Path.GetFileName(file.FileName);
                var physicalPath = Path.Combine(Server.MapPath("~/App_Data"), fileName);
                
                // The files are not actually saved in this demo
                // file.SaveAs(physicalPath);
            }

            // Return an empty string to signify success
            return Content("");
        }

        public ActionResult Remove(string[] fileNames)
        {
            // The parameter of the Remove action must be called "fileNames"

            foreach (var fullName in fileNames)
            {
                var fileName = Path.GetFileName(fullName);
                var physicalPath = Path.Combine(Server.MapPath("~/App_Data"), fileName);
                
                // TODO: Verify user permissions

                if (System.IO.File.Exists(physicalPath))
                {
                    // The files are not actually removed in this demo
                    // System.IO.File.Delete(physicalPath);
                }
            }

            // Return an empty string to signify success
            return Content("");
        }
    }
}