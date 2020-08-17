namespace EasyUI.Web.Mvc.Examples.Models
{
    using System.Linq;
    using System.ServiceModel;
    using System.ServiceModel.Activation;
    
    using EasyUI.Web.Mvc.Extensions;
using System.Collections.Generic;
using System.Web.Mvc;
    using System.ServiceModel.Web;
    using System.Threading;
    
    [ServiceContract(Namespace = "")]
    [ServiceBehavior(IncludeExceptionDetailInFaults = true)]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ProductsWcf
    {
        [OperationContract]
        public GridModel Select(GridState state)
        {
            return SessionProductRepository.All().AsQueryable().ToGridModel(state);
        }

        [OperationContract]
        public GridModel Update(GridState state, EditableProduct value)
        {
            SessionProductRepository.Update(value);

            return SessionProductRepository.All().AsQueryable().ToGridModel(state);
        }

        [OperationContract]
        public GridModel Insert(GridState state, EditableProduct value)
        {
            SessionProductRepository.Insert(value);

            return SessionProductRepository.All().AsQueryable().ToGridModel(state);
        }

        [OperationContract]
        public GridModel Delete(GridState state, EditableProduct value)
        {
            SessionProductRepository.Delete(value);

            return SessionProductRepository.All().AsQueryable().ToGridModel(state);
        }

        [OperationContract]
        public IEnumerable<SelectListItem> GetDropDownItems()
        {
            Thread.Sleep(1000);

            return new SelectList(SessionProductRepository.All(), "ProductID", "ProductName");
        }
     
        [OperationContract]
        public IEnumerable<SelectListItem> GetDropDownItemsWithParams(string text)
        {
            Thread.Sleep(1000);

            List<EditableProduct> products = SessionProductRepository.All().Where((p) => p.ProductName.StartsWith(text, System.StringComparison.OrdinalIgnoreCase)).ToList();

            return new SelectList(products, "ProductID", "ProductName");
        }

        [OperationContract]
        public IEnumerable<string> GetProductNames(string text)
        {
            Thread.Sleep(1000);

            List<EditableProduct> products = SessionProductRepository.All().Where((p) => p.ProductName.StartsWith(text, System.StringComparison.OrdinalIgnoreCase)).ToList();

            return products.Select(p => p.ProductName);
        }
    }
}