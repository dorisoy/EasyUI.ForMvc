namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;
    using EasyUI.Web.Mvc.Extensions;

    public partial class GridController : Controller
    {
        public ActionResult ServerRowTemplate()
        {
            var customers = SessionCustomerRepository.All();
            return View(customers);
        }

        public ActionResult ServerRowTemplate_Update(string id)
        {
            var customer = SessionCustomerRepository.One(c => c.CustomerID == id);

            if (customer != null)
            {
                if (TryUpdateModel(customer))
                {
                    SessionCustomerRepository.Update(customer);
                    return RedirectToAction("ServerRowTemplate", this.GridRouteValues());
                }
            }

            return View("ServerRowTemplate", SessionCustomerRepository.All());
        }

        public ActionResult ServerRowTemplate_Delete(string id)
        {
            var customer = SessionCustomerRepository.One(c => c.CustomerID == id);

            if (customer != null)
            {
                SessionCustomerRepository.Delete(customer);
            }

            return RedirectToAction("ServerRowTemplate", this.GridRouteValues());
        }
    }
}