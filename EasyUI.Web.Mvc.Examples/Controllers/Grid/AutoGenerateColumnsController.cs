namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    
    using Models;

    public partial class GridController : Controller
    {
        public ActionResult AutoGenerateColumns()
        {
            return View(SessionCustomerRepository.All());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [GridAction]
        public ActionResult _DeleteAutoColumnsEditing(string id)
        {
            EditableCustomer customer = SessionCustomerRepository.One(p => p.CustomerID == id);

            if (customer != null)
            {
                //Delete the record
                SessionCustomerRepository.Delete(customer);
            }

            //Rebind the grid
            return View(new GridModel(SessionCustomerRepository.All()));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [CultureAwareAction]
        [GridAction]
        public ActionResult _SaveAutoColumnsEditing(string id)
        {
            EditableCustomer customer = SessionCustomerRepository.One(p => p.CustomerID == id);

            TryUpdateModel(customer);

            SessionCustomerRepository.Update(customer);

            return View(new GridModel(SessionCustomerRepository.All()));
        }

        [GridAction]
        public ActionResult _SelectAutoGenerateColumns()
        {
            var customers = SessionCustomerRepository.All();
            return View(new GridModel
                            {
                                Data = customers,
                                Total = customers.Count
                            });
        }
    }
}