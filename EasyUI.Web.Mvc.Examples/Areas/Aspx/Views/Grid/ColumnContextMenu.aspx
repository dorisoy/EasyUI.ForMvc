<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:content contentplaceholderid="MainContent" runat="server">

<%: Html.EasyUI().Grid<EditableProduct>()
        .Name("Grid")
        .DataBinding(dataBinding =>
            dataBinding.Ajax()
                .Select("_SelectAjax", "Grid")
        )
        .Columns(columns =>
        {
            columns.Bound(p => p.ProductName).Width(210);
            columns.Bound(p => p.UnitPrice).Width(130).Format("{0:c}");
            columns.Bound(p => p.UnitsInStock).Width(130).Format("{0:N}");
            columns.Bound(p => p.LastSupply).Width(130).Format("{0:d}");
            columns.Bound(p => p.Discontinued)
                   .ClientTemplate("<input type='checkbox' disabled='disabled' name='Discontinued' <#= Discontinued? checked='checked' : '' #> />");
        })
        .Pageable()
        .Scrollable()
        .Resizable(config =>
            {
                config.Columns(true);
            })
        .Reorderable(config =>
            {
                config.Columns(true);
            })
        .ColumnContextMenu()
%>    
</asp:content>