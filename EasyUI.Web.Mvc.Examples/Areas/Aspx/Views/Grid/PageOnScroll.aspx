<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Order>>" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">

<% 
    
    Html.EasyUI().Grid(Model)
        .Name("Grid")
        .Columns(columns =>
        {
            columns.Bound(o => o.OrderID).Width(81);
            columns.Bound(o => o.Customer.ContactName).Width(200);
            columns.Bound(o => o.ShipAddress);
            columns.Bound(o => o.OrderDate).Format("{0:MM/dd/yyyy}").Width(100);
        })
        .DataBinding(dataBinding => dataBinding.Ajax().Select("_PageOnScroll", "Grid"))
        .Pageable(paging => paging.Style(GridPagerStyles.Status).PageOnScroll(true))
        .Render();
        
%>
</asp:content>
