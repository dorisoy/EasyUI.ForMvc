<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>


<asp:content contentplaceholderid="MainContent" runat="server">
<% 
    GridEditMode mode = (GridEditMode)ViewData["mode"];
    GridButtonType type = (GridButtonType)ViewData["type"];

    using (Html.Configurator("Edit mode")
              .PostTo("EditingAjax", "Grid")
              .Begin())
    { 
%>
    <ul>
        <li><%: Html.RadioButton("mode", "InLine", mode == GridEditMode.InLine, new { id = "inLine" })%><label for="inLine">In-line</label></li>
        <li><%: Html.RadioButton("mode", "InForm", mode == GridEditMode.InForm, new { id = "inForm" })%><label for="inForm">In-form</label></li>
        <li><%: Html.RadioButton("mode", "PopUp", mode == GridEditMode.PopUp, new { id = "popUp" })%><label for="popUp">Pop-up</label></li>
    </ul>
    <br />
    <h3 class="configurator-legend">
		Button type
	</h3>
    <ul>
        <li><%: Html.RadioButton("type", "Text", type == GridButtonType.Text, new { id = "text" })%><label for="text">Text</label></li>
        <li><%: Html.RadioButton("type", "Image", type == GridButtonType.Image, new { id = "image" })%><label for="image">Image</label></li>
        <li><%: Html.RadioButton("type", "ImageAndText", type == GridButtonType.ImageAndText, new { id = "imageAndText" })%><label for="imageAndText">Image and text</label></li>
        <li><%: Html.RadioButton("type", "BareImage", type == GridButtonType.BareImage, new { id = "bareImage" })%><label for="bareImage">Bare Image (no button borders)</label></li>
    </ul>
    <button type="submit" class="t-button">Apply</button>
<% 
    }
%>

<%: Html.EasyUI().Grid<EditableProduct>()
        .Name("Grid")
        .DataKeys(keys =>
        {
            keys.Add(p => p.ProductID);
        })
        .ToolBar(commands =>
        {
            commands.Insert().ButtonType(type).ImageHtmlAttributes(new { style = "margin-left:0" });
        })
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
            columns.Bound(p => p.ProductName).Width(210);
            columns.Bound(p => p.UnitPrice).Width(130).Format("{0:c}");
            columns.Bound(p => p.UnitsInStock).Width(130).Format("{0:N}");
            columns.Bound(p => p.LastSupply).Width(130).Format("{0:d}");
            columns.Bound(p => p.Discontinued)
                   .ClientTemplate("<input type='checkbox' disabled='disabled' name='Discontinued' <#= Discontinued? checked='checked' : '' #> />");
            columns.Command(commands =>
            {
                commands.Edit().ButtonType(type);
                commands.Delete().ButtonType(type);
            }).Width(180).Title("Commands");
        })
            .Editable(editing => editing
                .Mode(mode))
        .Pageable()
        .Scrollable()
        .Sortable()
%>

</asp:content>

<asp:content contentplaceholderid="HeadContent" runat="server">

<style type="text/css">
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
