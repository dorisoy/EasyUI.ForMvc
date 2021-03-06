<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

<% using (Html.BeginForm("ProcessSubmit", "Upload",
                         FormMethod.Post, new { id = "uploadForm", enctype = "multipart/form-data" })) { %>
    <%: Html.EasyUI().Upload()
            .Name("attachments")
    %>

    <p class="note">
        Maximum combined file size: 10 MB
    </p>

    <div style="margin: 20px 0 0 0;">
        <input type="submit" value="Send" class="t-button" />
        <input type="reset" value="Reset" class="t-button" />
    </div>
<% } %>

</asp:Content>
