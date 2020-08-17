namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Data.Linq;
    using System.Linq;
    using System.Web.Mvc;
    using Models;
    using EasyUI.Web.Mvc.Infrastructure;

    public partial class GridController : Controller
    {
        private static int count;

        [SourceCodeFile("Binding Helper", "~/Extensions/CustomBindingExtensions.cs")]
        public ActionResult CustomBinding()
        {
            IEnumerable data = GetData(new GridCommand());

            // Required for pager configuration
            ViewData["total"] = GetCount();

            return View(data);
        }

        [GridAction(EnableCustomBinding = true)]
        public ActionResult _CustomBinding(GridCommand command)
        {
            IEnumerable data = GetData(command);

            return View(new GridModel
                            {
                                Data = data,
                                Total = count
                            });
        }

        private static IEnumerable GetData(GridCommand command)
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

            count = data.Count();

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

        private static int GetCount()
        {
            using (NorthwindDataContext dataContext = new NorthwindDataContext())
            {
                return dataContext.Orders.Count();
            }
        }
    }
}