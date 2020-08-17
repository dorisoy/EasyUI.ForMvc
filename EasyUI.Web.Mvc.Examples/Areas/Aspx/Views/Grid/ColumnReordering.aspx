<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<OrderDto>>" %>

<%@ Import Namespace="System.Web.Script.Serialization" %>
<asp:content ID="Content1" contentplaceholderid="maincontent" runat="server">
<%
    var columnSettings = (IEnumerable<GridColumnSettings>)ViewData["Columns"];
%>    
<% Html.BeginForm("columnreordering", "grid"); %>    
<p>
    <%: Html.Hidden("positions", String.Join(",", columnSettings.Select(c => c.Member).ToArray())) %>
    <button class="t-button" type="submit">Save Column Positions</button>
</p>
<% Html.EndForm(); %>

<%: Html.EasyUI().Grid(Model)
        .Name("Grid")
        .Columns(columns => columns.LoadSettings(columnSettings))
        .Scrollable()
        .Reorderable(reorder => reorder.Columns(true))
        .Pageable()
        .ClientEvents(events => events
            .OnColumnReorder("onReorder"))
        .DataBinding(dataBinding => dataBinding.Ajax()
            .Select("_ColumnReordering", "Grid"))
%>
<script type="text/javascript">

    function onReorder(e) {
        var $positionsHidden = $('#positions');
        // convert the comma separated values to array of strings
        var positions = $positionsHidden.val().split(',');
        
        // remove the column from the array
        positions.splice(e.oldIndex, 1);
        
        // add the column member to the array
        positions.splice(e.newIndex, 0, e.column.member);

        // make the array to comma separated string and update the hidden field value
        $positionsHidden.val(positions.join(','));
    }
</script>
</asp:content>
