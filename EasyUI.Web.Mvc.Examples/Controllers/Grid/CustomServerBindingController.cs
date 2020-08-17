namespace EasyUI.Web.Mvc.Examples
{
    using System.Collections;
    using System.Data.Linq;
    using System.Linq;
    using System.Web.Mvc;
    using Models;

    public partial class GridController : Controller
    {
        [SourceCodeFile("Binding Helper", "~/Extensions/CustomBindingExtensions.cs")]
        [GridAction(GridName = "Grid")]
        public ActionResult CustomServerBinding(GridCommand command)
        {
            IEnumerable data = GetServerData(!IsEmptyCommand(command) ? command : new GridCommand());
            return View(data);
        }        

        private IEnumerable GetServerData(GridCommand command)
        {
            DataLoadOptions loadOptions = new DataLoadOptions();
            loadOptions.LoadWith<Order>(o => o.Customer);

            var dataContext = new NorthwindDataContext
            {
                LoadOptions = loadOptions
            };

            IQueryable<Order> data = dataContext.Orders;

            //Apply filtering
            data = data.ApplyFiltering(command.FilterDescriptors);

            ViewData["Total"] = data.Count();
            
            //Apply sorting
            data = data.ApplySorting(command.GroupDescriptors, command.SortDescriptors);            

            //Apply paging
            data = data.ApplyPaging(command.Page, command.PageSize);

            //Apply grouping
            if (command.GroupDescriptors.Any())
            {
                return data.ApplyGrouping(command.GroupDescriptors);
            }
            return data.ToList();
        }

        private bool IsEmptyCommand(GridCommand command)
        {
            return command.PageSize == 0;
        }
    }
}