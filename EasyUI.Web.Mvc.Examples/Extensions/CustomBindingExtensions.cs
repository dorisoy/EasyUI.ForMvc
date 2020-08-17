namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using Models;
    using EasyUI.Web.Mvc.Infrastructure;

    public static class CustomBindingExtensions
    {
        public static IQueryable<Order> ApplyFiltering(this IQueryable<Order> data, IList<IFilterDescriptor> filterDescriptors)
        {
            if (filterDescriptors.Any())
            {
                data = data.Where(ExpressionBuilder.Expression<Order>(filterDescriptors));
            }
            return data;
        }

        public static IEnumerable ApplyGrouping(this IQueryable<Order> data, IList<GroupDescriptor> groupDescriptors)
        {
            Func<IEnumerable<Order>, IEnumerable<AggregateFunctionsGroup>> selector = null;
            foreach (var group in groupDescriptors.Reverse())
            {
                if (selector == null)
                {
                    if (group.Member == "Customer.ContactName")
                    {
                        selector = orders => BuildInnerGroup(orders, o => o.Customer.ContactName);
                    }
                    else if (group.Member == "OrderID")
                    {
                        selector = orders => BuildInnerGroup(orders, o => o.OrderID);
                    }
                    else if (group.Member == "ShipAddress")
                    {
                        selector = orders => BuildInnerGroup(orders, o => o.ShipAddress);
                    }
                    else if (group.Member == "OrderDate")
                    {
                        selector = orders => BuildInnerGroup(orders, o => o.OrderDate);
                    }
                }
                else
                {
                    if (group.Member == "Customer.ContactName")
                    {
                        selector = BuildGroup(o => o.Customer.ContactName, selector);
                    }
                    else if (group.Member == "OrderID")
                    {
                        selector = BuildGroup(o => o.OrderID, selector);
                    }
                    else if (group.Member == "ShipAddress")
                    {
                        selector = BuildGroup(o => o.ShipAddress, selector);
                    }
                    else if (group.Member == "OrderDate")
                    {
                        selector = BuildGroup(o => o.OrderDate, selector);
                    }
                }
            }
            return selector.Invoke(data).ToList();
        }       

        private static Func<IEnumerable<Order>, IEnumerable<AggregateFunctionsGroup>> BuildGroup<T>(Func<Order, T> groupSelector, Func<IEnumerable<Order>, IEnumerable<AggregateFunctionsGroup>> selectorBuilder)
        {
            var tempSelector = selectorBuilder;

            return g => g.GroupBy(groupSelector)
                         .Select(c => new AggregateFunctionsGroup
                         {
                             Key = c.Key,
                             HasSubgroups = true,
                             Items = tempSelector.Invoke(c).ToList()
                         });
        }

        private static IEnumerable<AggregateFunctionsGroup> BuildInnerGroup<T>(IEnumerable<Order> group, Func<Order, T> groupSelector)
        {
            return group.GroupBy(groupSelector)
                    .Select(i => new AggregateFunctionsGroup
                    {
                        Key = i.Key,
                        Items = i.ToList()
                    });
        }

        public static IQueryable<Order> ApplyPaging(this IQueryable<Order> data, int currentPage, int pageSize)
        {
            if (pageSize > 0 && currentPage > 0)
            {
                data = data.Skip((currentPage - 1) * pageSize);
            }

            data = data.Take(pageSize);
            return data;
        }

        public static IQueryable<Order> ApplySorting(this IQueryable<Order> data,
            IList<GroupDescriptor> groupDescriptors, IList<SortDescriptor> sortDescriptors)
        {
            if (groupDescriptors.Any())
            {
                foreach (var groupDescriptor in groupDescriptors.Reverse())
                {
                    data = AddSortExpression(data, groupDescriptor.SortDirection, groupDescriptor.Member);
                }
            }

            if (sortDescriptors.Any())
            {
                foreach (SortDescriptor sortDescriptor in sortDescriptors)
                {
                    data = AddSortExpression(data, sortDescriptor.SortDirection, sortDescriptor.Member);
                }
            }
            return data;
        }

        private static IQueryable<Order> AddSortExpression(IQueryable<Order> data, ListSortDirection sortDirection, string memberName)
        {
            if (sortDirection == ListSortDirection.Ascending)
            {
                switch (memberName)
                {
                    case "OrderID":
                        data = data.OrderBy(order => order.OrderID);
                        break;
                    case "Customer.ContactName":
                        data = data.OrderBy(order => order.Customer.ContactName);
                        break;
                    case "ShipAddress":
                        data = data.OrderBy(order => order.ShipAddress);
                        break;
                    case "OrderDate":
                        data = data.OrderBy(order => order.OrderDate);
                        break;
                }
            }
            else
            {
                switch (memberName)
                {
                    case "OrderID":
                        data = data.OrderByDescending(order => order.OrderID);
                        break;
                    case "Customer.ContactName":
                        data = data.OrderByDescending(order => order.Customer.ContactName);
                        break;
                    case "ShipAddress":
                        data = data.OrderByDescending(order => order.ShipAddress);
                        break;
                    case "OrderDate":
                        data = data.OrderByDescending(order => order.OrderDate);
                        break;
                }
            }
            return data;
        }
    }
}