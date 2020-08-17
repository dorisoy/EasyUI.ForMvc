<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">
    
    <% using (Html.Configurator("Validation summary").Begin()) { %>
        <%: Html.ValidationSummary() %>
    <% } %>

    <% using (Html.BeginForm("servervalidation", "datepicker")) { %>

        <div>
            <label for="delay-input">Cake delay (required):</label>
            <%: Html.EasyUI().TimePicker()
                    .Name("delay")
            %>
            <%: Html.ValidationMessage("delay", "*") %>
        </div>

        <div>
            <label for="deliveryDate-input">Cake delivery date (required):</label>
            <%: Html.EasyUI().DatePicker()
                    .Name("deliveryDate")
            %>
            <%: Html.ValidationMessage("deliveryDate", "*") %>
        </div>

        <div>
            <label for="orderDateTime-input">Cake order date time (required):</label>
            <%: Html.EasyUI().DateTimePicker()
                    .Name("orderDateTime")
            %>
            <%: Html.ValidationMessage("orderDateTime", "*") %>
        </div>

        <p>
            <button class="t-button" type="submit">Save</button>
        </p>
    
    <% } %>
    
    <% if (ViewData["delay"] != null)
       { %>
             <p><strong>Posted value is : <%: Convert.ToDateTime(ViewData["delay"]).TimeOfDay %></strong></p>
    <% } %>

    <% if (ViewData["deliveryDate"] != null)
       { %>
             <p><strong>Posted value is : <%: ViewData["deliveryDate"] %></strong></p>
    <% } %>

    <% if (ViewData["orderDateTime"] != null)
       { %>
             <p><strong>Posted value is : <%: ViewData["orderDateTime"] %></strong></p>
    <% } %>
</asp:content>

<asp:content contentPlaceHolderId="HeadContent" runat="server">
    <style type="text/css">
        
        .field-validation-error { color: red; position: absolute; margin: 0 0 0 5px; }
   
    </style>
</asp:content>