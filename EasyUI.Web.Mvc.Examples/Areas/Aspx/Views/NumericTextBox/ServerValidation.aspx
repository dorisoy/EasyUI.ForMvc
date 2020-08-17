<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentplaceholderid="MainContent" runat="server">
        
    <% using (Html.Configurator("Validation summary").Begin()) { %>
        <%: Html.ValidationSummary() %>
    <% } %>

    <% using (Html.BeginForm("servervalidation", "numerictextbox")) { %>

        <div>
            <label for="piecesOfCake">Pieces of cake (required):</label>
            <%: Html.EasyUI().NumericTextBox()
                              .Name("piecesOfCake")
            %>
            <%: Html.ValidationMessage("piecesOfCake", "*")%>
        </div>

        <p>
            <button class="t-button" type="submit">Save</button>
        </p>
    
    <% } %>
    
    <% if (ViewData["piecesOfCake"] != null)
       { %>
        <p><strong>Posted value is : <%: ViewData["piecesOfCake"]%></strong></p>
    <% } %>
    
</asp:content>

<asp:content contentPlaceHolderId="HeadContent" runat="server">
    <style type="text/css">
      
        .field-validation-error { color: red; position: absolute; margin: 0 0 0 5px; }
   
    </style>
</asp:content>