<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Order>>" %>


<asp:content contentplaceholderid="MainContent" runat="server">

<% Html.EasyUI().Grid(Model)
        .Name("Grid")
        .Columns(columns =>
        {
            columns.Bound(o => o.OrderID)
                   .ClientTemplate("<input type='checkbox' name='checkedRecords' value='<#= OrderID #>' />")
                   .Title("")
                   .Width(36)
                   .HtmlAttributes(new { style = "text-align:center" });
            
            columns.Bound(o => o.OrderID).Width(100);
            columns.Bound(o => o.Customer.ContactName).Width(200);
            columns.Bound(o => o.ShipAddress);
            columns.Bound(o => o.OrderDate).Format("{0:MM/dd/yyyy}").Width(120);
        })
        .DataBinding(dataBinding => dataBinding.Ajax()
                .Select("_CheckBoxesAjax", "Grid"))
        .Scrollable()
        .Pageable()
        .Render();
%>    
<p>
    <button class="t-button" onclick="displayCheckedOrders()">Display checked orders</button>
    <script type="text/javascript">        
        function displayCheckedOrders() {
            var $checkedRecords = $(':checked');
            
            if ($checkedRecords.length < 1) {
                alert('Check a few grid rows first.');
                return;
            }                         
            
            $('#result').load('<%: Url.Action("DisplayCheckedOrders", "Grid") %>', $checkedRecords);
        }
    </script>
</p>

<div id="result">
</div>
</asp:content>
