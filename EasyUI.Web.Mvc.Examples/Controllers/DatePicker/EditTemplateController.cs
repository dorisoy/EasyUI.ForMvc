namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class DatePickerController : Controller
    {
        [SourceCodeFile("OrderInfo.cs", "~/Models/OrderInfo.cs", Order = 1)]
        [SourceCodeFile(
            FileName = "~/Views/Shared/EditorTemplates/Date.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/Date.ascx")]
        [SourceCodeFile(
            FileName = "~/Views/Shared/EditorTemplates/Time.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/Time.ascx")]
        [SourceCodeFile(
            FileName = "~/Views/Shared/EditorTemplates/DateTime.cshtml",
            AspxFileName = "~/Areas/Aspx/Views/Shared/EditorTemplates/DateTime.ascx")]
        public ActionResult EditTemplate(OrderInfo orderInfo)
        {
            if (orderInfo.OrderInfoID == 0)
            {
                orderInfo.OrderInfoID = 1;
                orderInfo.Delay = new DateTime(2010, 1, 1, 10, 0, 0);
                orderInfo.DeliveryDate = new DateTime(2010, 1, 1);
                orderInfo.OrderDateTime = new DateTime(2010, 1, 1, 10, 0, 0);
            }
            else
            {
                ViewData["orderInfo"] = orderInfo;
            }

            return View(orderInfo);
        }
    }
}