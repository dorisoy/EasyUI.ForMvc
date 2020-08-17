<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Examples.Master" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">

    function dump(obj) {
       obj = obj || {};        
       var result = [];
       $.each(obj, function(key, value) { result.push('"' + key + '":"' + value + '"');});
       return '{' + result.join(',') + '}';
    }
    
    function onLoad(e) {
        $console.log("Grid loaded");
    }

    function onDataBinding(e) {
        $console.log("OnDataBinding");
    }

    function onDataBound(e) {
        $console.log("OnDataBound");
    }

    function onCommand(e) {
        $console.log("OnCommand :: " + dump({ name: e.name }));
    }

    function onComplete(e) {
        $console.log("OnComplete :: " + dump({ name: e.name }));
    }

    function onRowDataBound(e) {        
        var dataItem = e.dataItem;
        $console.log("OnRowDataBound :: " + dump(dataItem));
    }

    function onRowSelect(e) {
        var row = e.row;
        $console.log("OnRowSelect :: " + row.cells[1].innerHTML);
    }
    
    function onDetailViewExpand(e) {
        $console.log("OnDetailViewExpand :: " + e.masterRow.cells[1].innerHTML);
    }
    
    function onDetailViewCollapse(e) {
        $console.log("OnDetailViewCollapse :: " + e.masterRow.cells[1].innerHTML);
    }

    function onEdit(e) {
        $console.log("OnEdit :: " + dump(e.dataItem));
    }
    
    function onDelete(e) {
        $console.log("OnDelete :: " + dump(e.dataItem));
    }

    function onSave(e) {
        $console.log("OnSave :: " + dump(e.values));
    }

    function onColumnResize(e) {
        var column = e.column;
        var oldWidth = e.oldWidth;
        var newWidth = e.newWidth;
        
        $console.log("OnColumnResize :: '" + column.title + "' from " + oldWidth + "px to " + newWidth + "px");
    }    
    
    function onColumnReorder(e) {
        var column = e.column;
        var oldIndex = e.oldIndex;
        var newIndex = e.newIndex;
        
        $console.log("OnColumnReorder :: '" + column.title + "' from " + oldIndex + " to " + newIndex);
    }
    </script>

    <%: Html.EasyUI().Grid<EditableProduct>()
        .Name("Grid")
        .DataKeys(keys => 
        {
            keys.Add(p => p.ProductID);
        })
        .ToolBar(commands => commands.Insert())
        .DataBinding(dataBinding =>
        {
            dataBinding.Ajax()
                .Select("_SelectAjaxEditing", "Grid")
                .Insert("_InsertAjaxEditing", "Grid")
                .Update("_SaveAjaxEditing", "Grid")
                .Delete("_DeleteAjaxEditing", "Grid");
        })
        .DetailView(detailView => detailView.ClientTemplate(
                "<fieldset>"+
                  "<legend>Details for <#= ProductName #></legend>" +
                    "<ul style='padding:0;margin:0;list-style:none'>" +
                        "<li>ProductID: <#= ProductID #></li>" +
                        "<li>Unit Price: <#= UnitPrice #></li>" +
                        "<li>Units In Stock: <#= UnitsInStock #></li>" +
                    "</ul>" +
                "</fieldset>"
            ))
        .Columns(columns =>
        {
            columns.Bound(p => p.ProductName);
            columns.Bound(p => p.UnitPrice).Width(130).Format("{0:c}");
            columns.Bound(p => p.UnitsInStock).Width(130).Format("{0:N4}");
            columns.Bound(p => p.Discontinued).Width(100)
                   .ClientTemplate("<input type='checkbox' disabled='disabled' name='Discontinued' <#= Discontinued? checked='checked' : '' #> />");
            columns.Command(commands =>
            {
                commands.Edit();
                commands.Delete();
            }).Width(180).Title("Commands");
        })
        .ClientEvents(events => events
                .OnLoad("onLoad")
                .OnEdit("onEdit")
                .OnDetailViewCollapse("onDetailViewCollapse")
                .OnCommand("onCommand")
                .OnComplete("onComplete")
                .OnDetailViewExpand("onDetailViewExpand")
                .OnDelete("onDelete")
                .OnSave("onSave")
                .OnDataBinding("onDataBinding")
                .OnRowDataBound("onRowDataBound")
                .OnRowSelect("onRowSelect")
                .OnDataBound("onDataBound")
                .OnColumnResize("onColumnResize")
                .OnColumnReorder("onColumnReorder"))
        .Pageable(paging => paging.PageSize(4))
        .Resizable(resize => resize.Columns(true))
        .Reorderable(reorder => reorder.Columns(true))
        .Sortable()
        .Selectable()
        .Scrollable()
        .Filterable()
        .HtmlAttributes(new { style = "margin-bottom: 1.3em" }) 
    %>

    <% Html.RenderPartial("EventLog"); %>
</asp:content>
