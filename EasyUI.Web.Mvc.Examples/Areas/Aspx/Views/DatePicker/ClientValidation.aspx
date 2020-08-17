<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<OrderInfoDto>" %>
<asp:content contentPlaceHolderId="MainContent" runat="server">
    <% Html.EnableClientValidation(); %>
    
    <% using (Html.BeginForm())
       { %>
        <ul id="field-list">
            <li>
                <%: Html.LabelFor(o => o.Delay) %>
                <%: Html.EasyUI().TimePickerFor(o => o.Delay) %>
                <%: Html.ValidationMessageFor(x => x.Delay) %>
            </li>
            <li>
                <%: Html.LabelFor(o => o.DeliveryDate) %>
                <%: Html.EasyUI().DatePickerFor(o => o.DeliveryDate) %>
                <%: Html.ValidationMessageFor(o => o.DeliveryDate) %>
            </li>
            <li>
                <%: Html.LabelFor(o => o.OrderDateTime) %>
                <%: Html.EasyUI().DateTimePickerFor(o => o.OrderDateTime) %>
                <%: Html.ValidationMessageFor(o => o.OrderDateTime) %>
            </li>
            <li>
                <button class="t-button" type="submit">Save</button>
            </li>
        </ul>
    <% } %>   
</asp:content>

<asp:content contentPlaceHolderId="HeadContent" runat="server">

    <% Html.EasyUI().ScriptRegistrar()
                     .DefaultGroup(group => group
                         .Add("MicrosoftAjax.js")
                         .Add("MicrosoftMvcValidation.js")); %>
                         
    <style type="text/css">
        .field-validation-error { color: red; position: absolute; margin: 0 0 0 5px; }
        
        #field-list
        {
            display: inline-block; *display: inline; zoom: 1;
            overflow: hidden;
        }
        
        #field-list li
        {
            list-style-type: none;
            padding-bottom: 5px;
        }
        
        #field-list label
        {
            display: inline-block; *display: inline; zoom: 1;
            width: 120px; text-align: right; padding-right: 5px;
            vertical-align: top;
            padding-top: 2px;
        }
        
        #field-list .text-box,
        #field-list .t-datepicker,
        #field-list textarea
        {
            font: normal 12px Tahoma;
        }
        
        #field-list #OrderDate
        {
            width: 12.1em;
        }
        
        #field-list .text-box,
        #field-list textarea
        {
            width: 10em;
        }
        
        #field-list button
        {
            margin: 1em 0 0 16.3em;
            width: 5em;
        }
    </style>
</asp:content>