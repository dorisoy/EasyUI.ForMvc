namespace EasyUI.Web.Mvc.Examples.Models
{
    using System.ComponentModel;
    using System.Linq;
    using System.Web.Script.Services;
    using System.Web.Services;
    using EasyUI.Web.Mvc.Extensions;
    using System.Collections.Generic;
    using System.Web.Mvc;
    using System.Web.Script.Serialization;
    using EasyUI.Web.Mvc.UI;
    using System.Threading;

    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    [ScriptService]
    public class ProductsAsmx : WebService
    {
        [WebMethod(EnableSession = true)] //Session required by SessionCustomerRepository
        public GridModel Select(GridState state)
        {
            return SessionProductRepository.All().AsQueryable().ToGridModel(state);
        }

        [WebMethod(EnableSession = true)] //Session required by SessionCustomerRepository
        public GridModel Update(EditableProduct value, GridState state)
        {
            SessionProductRepository.Update(value);

            return SessionProductRepository.All().AsQueryable().ToGridModel(state);
        }

        [WebMethod(EnableSession = true)] //Session required by SessionCustomerRepository
        public GridModel Insert(EditableProduct value, GridState state)
        {
            SessionProductRepository.Insert(value);

            return SessionProductRepository.All().AsQueryable().ToGridModel(state);
        }
        
        [WebMethod(EnableSession = true)] //Session required by SessionCustomerRepository
        public GridModel Delete(EditableProduct value, GridState state)
        {
            SessionProductRepository.Delete(value);

            return SessionProductRepository.All().AsQueryable().ToGridModel(state);
        }

        [WebMethod(EnableSession = true)] //Session required by SessionCustomerRepository
        public IEnumerable<SelectListItem> GetDropDownItems()
        {
            Thread.Sleep(1000);

            return new SelectList(SessionProductRepository.All(), "ProductID", "ProductName");
        }

        [WebMethod(EnableSession = true)] //Session required by SessionCustomerRepository
        public IEnumerable<SelectListItem> GetDropDownItemsWithParams(string text)
        {
            Thread.Sleep(1000);

            List<EditableProduct> products = SessionProductRepository.All().Where((p) => p.ProductName.StartsWith(text, System.StringComparison.OrdinalIgnoreCase)).ToList();

            return new SelectList(products, "ProductID", "ProductName");
        }

        [WebMethod(EnableSession = true)] //Session required by SessionCustomerRepository
        public IEnumerable<string> GetProductNames(string text)
        {
            Thread.Sleep(1000);

            List<EditableProduct> products = SessionProductRepository.All().Where((p) => p.ProductName.StartsWith(text, System.StringComparison.OrdinalIgnoreCase)).ToList();

            return products.Select(p => p.ProductName);
        }
    }
}