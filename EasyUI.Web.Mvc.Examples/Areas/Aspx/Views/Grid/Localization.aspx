<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:Content contentPlaceHolderID="MainContent" runat="server">

<% Html.RenderPartial("CulturePicker"); %>

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
        .Columns(columns =>
        {
            columns.Bound(p => p.ProductName);
            columns.Bound(p => p.UnitPrice).Width(130).Format("{0:C}");
            columns.Bound(p => p.UnitsInStock).Width(130);
            columns.Bound(p => p.Discontinued).Width(100).ClientTemplate("<input type='checkbox' disabled='disabled' name='Discontinued' <#= Discontinued? \"checked='checked'\" : \"\" #> />");
            columns.Bound(p => p.LastSupply).Width(130).Format("{0:d}");
            columns.Command(commands =>
            {
                commands.Edit();
                commands.Delete();
            }).Width(180).Title("Commands");
        })
        .Pageable()
        .Scrollable()
        .Sortable()
        .Groupable()
%>

<% Html.EasyUI().ScriptRegistrar().Globalization(true); %>
</asp:Content>