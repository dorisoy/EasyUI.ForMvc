namespace EasyUI.Web.Mvc.Examples
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Web;
    using System.Web.Mvc;

    public partial class UploadController : Controller
    {
        public ActionResult SyncUpload()
        {
            return View();
        }

        public ActionResult SyncUploadResult()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ProcessSubmit(IEnumerable<HttpPostedFileBase> attachments)
        {
            if (attachments != null)
            {
                TempData["UploadedAttachments"] = GetFileInfo(attachments);
            }

            return RedirectToAction("SyncUploadResult");
        }

        private IEnumerable<string> GetFileInfo(IEnumerable<HttpPostedFileBase> attachments)
        {
            return
                from a in attachments
                where a != null
                select string.Format("{0} ({1} bytes)", Path.GetFileName(a.FileName), a.ContentLength);
        }
    }
}