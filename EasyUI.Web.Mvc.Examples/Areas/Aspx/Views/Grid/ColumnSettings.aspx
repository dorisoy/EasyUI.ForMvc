<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EditableProduct>>" %>


<asp:content contentplaceholderid="MainContent" runat="server">

<%: Html.EasyUI().Grid(Model)
        .Name("Grid")
        .DataKeys(keys => keys.Add(c => c.ProductID))
        .DataBinding(dataBinding => dataBinding.Server()
            .Select("ColumnSettings", "Grid")
            .Update("ColumnSettings_Save", "Grid")
            .Delete("ColumnSettings_Delete", "Grid"))
        .Columns(columns => columns.LoadSettings((IEnumerable<GridColumnSettings>)ViewData["Columns"]))
        .Pageable()
        .Sortable()
%>

</asp:content>

<asp:content contentplaceholderid="HeadContent" runat="server">
<style type="text/css">
    /* validators */
    .field-validation-error
    {
        position: absolute;
        display: block;
    }
    
    * html .field-validation-error { position: relative; }
    *+html .field-validation-error { position: relative; }
    
    .field-validation-error span
    {
        position: absolute;
        white-space: nowrap;
        color: red;
        padding: 17px 5px 3px;
        background: transparent url('<%: Url.Content("~/Content/Common/validation-error-message.png") %>') no-repeat 0 0;
    }
    
    /* in-form editing */
    .t-edit-form-container
    {
        width: 350px;
        margin: 1em;
    }
    
    .t-edit-form-container .editor-label,
    .t-edit-form-container .editor-field
    {
        padding-bottom: 1em;
        float: left;
    }
    
    .t-edit-form-container .editor-label
    {
        width: 30%;
        text-align: right;
        padding-right: 3%;
        clear: left;
    }
    
    .t-edit-form-container .editor-field
    {
        width: 60%;
    }
</style>
</asp:content>
