namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class GridController : Controller
    {
        public ActionResult ClientRowTemplate()
        {
            return View();
        }

        [GridAction]
        public ActionResult ClientRowTemplate_Select()
        {
            var customers = SessionCustomerRepository.All();

            return View(new GridModel(customers));
        }

        [GridAction]
        public ActionResult ClientRowTemplate_Update(string id)
        {
            var customer = SessionCustomerRepository.One(c => c.CustomerID == id);

            if (customer != null)
            {
                if (TryUpdateModel(customer))
                {
                    SessionCustomerRepository.Update(customer);
                }
            }

            return View(new GridModel(SessionCustomerRepository.All()));
        }

        [GridAction]
        public ActionResult ClientRowTemplate_Delete(string id)
        {
            var customer = SessionCustomerRepository.One(c => c.CustomerID == id);

            if (customer != null)
            {
                SessionCustomerRepository.Delete(customer);
            }

            return View(new GridModel(SessionCustomerRepository.All()));
        }
    }
}