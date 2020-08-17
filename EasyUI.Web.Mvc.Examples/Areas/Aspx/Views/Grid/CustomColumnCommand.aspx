<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Order>>" %>

<asp:content contentplaceholderid="MainContent" runat="server">

<%: Html.EasyUI().Grid(Model)
		.Name("Grid")
        .Columns(columns =>
        {
            columns.Bound(o => o.OrderID).Width(100);
            columns.Bound(o => o.Customer.ContactName).Width(200);
            columns.Bound(o => o.ShipAddress);
            columns.Command(commands => commands
                    .Custom("viewDetails")
                    .Text("Customer Details")
                    .DataRouteValues(route => route.Add(o => o.OrderID).RouteKey("orderID"))
                    .Ajax(true)
                    .Action("ViewDetails", "Grid"))
                .HtmlAttributes(new { style = "text-align: center" })
                .Width(150);
        })
        .ClientEvents(events => events.OnComplete("onComplete"))
		.DataBinding(dataBinding => dataBinding.Ajax().Select("_CustomCommand", "Grid"))
        .Pageable()
        .Sortable()
        .Filterable()
%>

<% Html.EasyUI().Window()
        .Name("Details")
        .Visible(false)
        .Title("Customer Details")
        .Modal(true)
        .Width(500)
        .Height(200)
        .Content(() =>
            {
                %>
                    <div id="customer-details">
                        <img />
                        <h2></h2>
                        <em></em>
                        <address></address>
                        <dl>
                            <dt>Phone:</dt>
                            <dd></dd>
                        </dl>
                    </div>
                <%
            })
        .Render();
%>
<script type="text/javascript">
function onComplete(e) {
   if (e.name == "viewDetails") {
        var detailWindow = $("#Details").data("tWindow");       
        var customer = e.response.customer;

        $("#customer-details")
            .find("img")
            .attr("src", '<%: Url.Content("~/Content/Grid/Customers/") %>' + customer.CustomerID + ".jpg")
            .end()
            .find("h2")
            .text(customer.ContactName)
            .end()
            .find("em")
            .text(customer.ContactTitle + ", " + customer.CompanyName)
            .end()
            .find("address")
            .text(customer.Address + ", " + customer.City + ", " + customer.Country)
            .end()
            .find("dd")
            .text(customer.Phone);

        detailWindow.center().open();
   } 
}
</script>
</asp:content>
<asp:Content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
    #customer-details
    {
        padding: 10px;        
        margin: 25px auto;
        width: 300px;
    }

    #customer-details h2
    {
        margin: 0;
    }

    #customer-details em
    {
        font-style: normal;
        color: #8c8c8c;
    }
    #customer-details address
    {
        margin: 10px 0 0 0;
    }

    #customer-details dl
    {
        float:left;
    }
    
    #customer-details dt,
    #customer-details dd
    {
        margin:0;
        display: inline; 
    }

    #customer-details dd
    {
        font-weight: bold;
    }

    #customer-details img
    {
        float:left;
        margin: 0 10px 10px 0;
    }
</style>
</asp:Content>