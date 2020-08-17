<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<ProductDto>" %>
<asp:content contentPlaceHolderId="MainContent" runat="server">

    <% Html.EnableClientValidation(); %>
    
    <% using (Html.BeginForm())
    { %>
        <div class="editing-section">
            <div class="section-title">Edit Customer</div>

            <ul id="field-list">
                <li class="field">
                    <label for="ProductID-input">Product Name</label>
                    <%: Html.EasyUI().ComboBoxFor(x => x.ProductID)
                            .DataBinding(binding => binding.Ajax().Select("_AjaxLoading", "ComboBox"))
                            .Filterable(filtering => filtering.FilterMode(AutoCompleteFilterMode.StartsWith))
                    %>
                    <div class="error"><%: Html.ValidationMessageFor(x => x.ProductID)%></div>
                </li>
                <li class="field">
                    <%: Html.LabelFor(x => x.UnitPrice)%>
                    <%: Html.EasyUI().NumericTextBoxFor(x => x.UnitPrice).InputHtmlAttributes(new { style = "width:145px" })%>
                </li>
                <li class="action-row">
                    <button class="t-button" type="submit">Save</button>
                </li>
            </ul>
        </div>
    <% } %> 

    <% if (ViewData["productID"] != null)
       { %>
             <p><strong>Posted value is : <%: ViewData["productID"]%></strong></p>
    <% } %>
</asp:content>

<asp:content contentPlaceHolderId="HeadContent" runat="server">

    <% Html.EasyUI().ScriptRegistrar()
                     .DefaultGroup(group => group
                         .Add("MicrosoftAjax.js")
                         .Add("MicrosoftMvcValidation.js")); %>
                         
    <style type="text/css">
        .editing-section
        {
            width: 700px;
            margin: 0 auto;
        }
        
        .section-title
        {
            font: 24px Arial,Helvetica,sans-serif;
            border-bottom: 1px solid #989898;
        }
        
        #field-list
        {
            border-top: 1px solid #d1d1d1;
            list-style-type: none;
            margin-top: 0;
            padding: 40px 0 0;
        }
        
        #field-list .field
        {
            list-style-type: none;
            overflow: hidden;
            white-space: nowrap;
        }
        
        #field-list label
        {
            float: left;
            width: 120px; text-align: right; padding-right: 5px;
            vertical-align: top;
            padding-top: 2px;
        }
        
        #field-list input,
        #field-list textarea
        {
            font: normal 12px Tahoma;
        }
        
        #field-list .error
        {
            color: red;
            clear: both;
            margin-left: 125px;
            font: 10px Arial,Helvetica,sans-serif;
            height: 15px;
        }
        
        #field-list .action-row { width: 275px; padding-top: 1.5em; height: 2em; }
        #field-list .action-row .t-button { float:right; width:60px; }
   
    </style>
</asp:content>