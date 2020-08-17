<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable>" %>
<asp:Content contentPlaceHolderID="MainContent" runat="server">

<%: Html.EasyUI().Grid<Order>()
		.Name("Grid")
        .BindTo(Model)
        .Columns(columns =>
        {
            columns.Bound(o => o.OrderID).Width(100);
            columns.Bound(o => o.Customer.ContactName).Width(200);
            columns.Bound(o => o.ShipAddress);
            columns.Bound(o => o.OrderDate).Format("{0:MM/dd/yyyy}").Width(100);
        })
        .DataBinding(dataBinding => dataBinding.Server().Select("CustomServerBinding", "Grid"))
        .Pageable(settings => settings.Total((int)ViewData["total"]))
		.EnableCustomBinding(true)
		.Sortable()
        .Filterable()
        .Groupable()
%>
	
</asp:Content>

