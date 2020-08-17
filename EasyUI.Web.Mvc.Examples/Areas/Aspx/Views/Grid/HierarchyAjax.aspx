<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<%: Html.EasyUI().Grid<EmployeeViewModel>()
        .Name("Employees")
        .Columns(columns =>
        {
            columns.Bound(e => e.FirstName).Width(140);
            columns.Bound(e => e.LastName).Width(140);
            columns.Bound(e => e.Title).Width(200);
            columns.Bound(e => e.Country).Width(200);
            columns.Bound(e => e.City);
        })
        .ClientEvents(events => events.OnRowDataBound("employees_onRowDataBound"))
        .DetailView(details => details.ClientTemplate(
                Html.EasyUI().Grid<OrderViewModel>()
                    .Name("Orders_<#= EmployeeID #>")
                    .Columns(columns =>
                    {
                        columns.Bound(o => o.OrderID).Width(101);
                        columns.Bound(o => o.ShipCountry).Width(140);
                        columns.Bound(o => o.ShipAddress).Width(200);
                        columns.Bound(o => o.ShipName).Width(200);
                        columns.Bound(o => o.ShippedDate).Format("{0:d}");
                    })
                    .ClientEvents(events => events.OnRowDataBound("orders_onRowDataBound"))
                    .DetailView(ordersDetailView => ordersDetailView.ClientTemplate(
                        Html.EasyUI().Grid<OrderDetailsViewModel>()
                            .Name("OrderDetails_<#= OrderID #>")
                            .Columns(columns =>
                            {
                                columns.Bound(od => od.ProductName).Width(233);
                                columns.Bound(od => od.Quantity).Width(200);
                                columns.Bound(od => od.UnitPrice).Width(200);
                                columns.Bound(od => od.Discount);
                            })
                            .DataBinding(dataBinding => dataBinding.Ajax()
                                 .Select("_OrderDetailsForOrderHierarchyAjax", "Grid", new { orderID = "<#= OrderID #>" }))
                            .Pageable()
                            .Sortable()
                            .ToHtmlString()
                     ))
                    .DataBinding(dataBinding => dataBinding.Ajax()
                        .Select("_OrdersForEmployeeHierarchyAjax", "Grid", new { employeeID = "<#= EmployeeID #>" }))
                    .Pageable()
                    .Sortable()
                    .Filterable()
                    .ToHtmlString()
        ))
        .DataBinding(dataBinding => dataBinding.Ajax().Select("_EmployeesHierarchyAjax", "Grid"))
        .Pageable(paging => paging.PageSize(5))
        .Scrollable(scrolling => scrolling.Height(580))
        .Sortable()
    %>
    <script type="text/javascript">
    
    function expandFirstRow(grid, row) {
        if (grid.$rows().index(row) == 0) {
            grid.expandRow(row);
        }
    }
    
    function employees_onRowDataBound(e) {
        var grid = $(this).data('tGrid');
        expandFirstRow(grid, e.row);
    }
    
    function orders_onRowDataBound(e) {
        var grid = $(this).data('tGrid');
        expandFirstRow(grid, e.row);
    }

    </script>
</asp:Content>