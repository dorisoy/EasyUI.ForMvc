<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Employee>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <% Html.EasyUI().Grid(Model)
        .Name("Employees")
        .Columns(columns =>
        {
            columns.Bound(e => e.FirstName).Width(140);
            columns.Bound(e => e.LastName).Width(140);
            columns.Bound(e => e.Title).Width(200);
            columns.Bound(e => e.Country).Width(200);
            columns.Bound(e => e.City);
        })
        .DetailView(detailView => detailView.Template(e =>
        {
            %>
                <% Html.EasyUI().Grid(e.Orders)
                       .Name("Orders_" + e.EmployeeID)
                       .Columns(columns =>
                        {
                            columns.Bound(o => o.OrderID).Width(101);
                            columns.Bound(o => o.ShipCountry).Width(140);
                            columns.Bound(o => o.ShipAddress).Width(200);
                            columns.Bound(o => o.ShipName).Width(200);
                            columns.Bound(o => o.ShippedDate).Format("{0:d}");
                        })
                       .DetailView(ordersDetailView => ordersDetailView.Template(o =>
                        {
                            %>
                                <%: Html.EasyUI().Grid(o.Order_Details)
                                        .Name("OrderDetails_" + o.EmployeeID + "_" +  o.OrderID)
                                        .Columns(columns =>
                                        {
                                            columns.Bound(od => od.Product.ProductName).Width(233);
                                            columns.Bound(od => od.Quantity).Width(200);
                                            columns.Bound(od => od.UnitPrice).Width(200);
                                            columns.Bound(od => od.Discount);
                                        })
                                        .Pageable()
                                        .Sortable()
                                %>
                            <%
                        }))
                       .RowAction(row => 
                        {
                            if (row.Index == 0)
                            {
                                row.DetailRow.Expanded = true;
                            }
                            else
                            {
                                var requestKeys = Request.QueryString.Keys.Cast<string>();
                                var expanded = requestKeys.Any(key => key.StartsWith("OrderDetails_" + row.DataItem.EmployeeID + "_" + row.DataItem.OrderID));
                                row.DetailRow.Expanded = expanded;
                            }
                        })
                       .Pageable()
                       .Sortable()
                       .Filterable()
                       .Render();
                %>
            <%    
        }))
        .RowAction(row => 
        {
            if (row.Index == 0)
            {
                row.DetailRow.Expanded = true;
            }
            else
            {
                var requestKeys = Request.QueryString.Keys.Cast<string>();
                var expanded = requestKeys.Any(key => key.StartsWith("Orders_" + row.DataItem.EmployeeID) || key.StartsWith("OrderDetails_" + row.DataItem.EmployeeID));
                row.DetailRow.Expanded = expanded;
            }
        })
        .Pageable(paging => paging.PageSize(5))
        .Sortable()
        .Render();
    %>
</asp:Content>
