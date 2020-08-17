namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using Models;

    [HandleError]
    public partial class DatePickerController : Controller
    {
        [SourceCodeFile("OrderInfoDto.cs", "~/Models/OrderInfoDto.cs")]
        public ActionResult ClientValidation()
        {
            OrderInfoDto dto =
                new OrderInfoDto
                {
                    OrderInfoID = 1,
                    Delay = null,
                    DeliveryDate = null,
                    OrderDateTime = null
                };

            return View(dto);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ClientValidation(OrderInfoDto dto)
        {
            return View(dto);
        }
    }
}