<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%: Html.EasyUI().Grid<Order>()
        .Name("Grid")
        .HtmlAttributes(new { style = "border: 0;" })
        .Columns(columns =>
		{
            columns.Bound(o => o.OrderID).Width(100);

            columns.Bound(o => o.Customer.ContactName).Width(200);
                                    
            columns.Bound(o => o.ShipAddress);
        })
        .DataBinding(dataBinding => dataBinding.Ajax().Select("_AjaxBinding", "Grid"))
        .Pageable(paging => paging.PageSize(20))
        .Scrollable(scrollable => scrollable.Height("246px"))
        .Sortable()
%>