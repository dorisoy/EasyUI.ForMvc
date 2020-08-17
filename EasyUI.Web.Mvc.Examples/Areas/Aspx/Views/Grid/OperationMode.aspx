<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" contentPlaceHolderID="MainContent" runat="server">
<% using (Html.Configurator("The operation mode ...")
              .PostTo("OperationMode", "Grid")
              .Begin())
   { %>
    <ul>
        <li>
            <label for="mode">Operation Mode</label>
            <%: Html.DropDownList("operationMode", new SelectList(new[] { GridOperationMode.Client, GridOperationMode.Server }))%>
        </li>
    </ul>
    <button class="t-button" type="submit">Apply</button>
<% } %>

<%: Html.EasyUI().Grid<OrderDto>()
        .Name("Grid")
        .Columns(columns =>
		{
            columns.Bound(o => o.OrderID).Width(100);
            columns.Bound(o => o.ContactName).Width(200);
            columns.Bound(o => o.ShipAddress);
            columns.Bound(o => o.OrderDate).Format("{0:MM/dd/yyyy}").Width(120);
        })
        .DataBinding(dataBinding => dataBinding.Ajax()
                .OperationMode((GridOperationMode)ViewData["OperationMode"])
                .Select("_OperationMode", "Grid"))
        .Pageable()
        .Sortable()
        .Scrollable()
        .Groupable()
        .Filterable()
        .ClientEvents(events => events.OnLoad("grid_load")
            .OnDataBinding("grid_dataBinding")
            .OnDataBound("grid_dataBound"))
%>
<br />
<% Html.RenderPartial("EventLog"); %>

    <script type="text/javascript">
        var start;

        function grid_load() {
            $(this).bind({
                ajaxSend: function() { $console.log("Requesting data from the server."); }                
            }); 
        }

        function grid_dataBound() {            
            $console.log("Bound in <b>" + (new Date().getTime() - start.getTime()) + "</b> milliseconds");
        }

        function grid_dataBinding() {
            start = new Date();            
        }
    </script>
</asp:Content>