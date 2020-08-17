<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <%: Html.EasyUI().Upload()
            .Name("attachments")
    %>

    <% using (Html.Configurator("Client API").Begin()) { %>
        <p>
            <button class="t-button" onclick="Disable()">Disable</button> /
            <button class="t-button" onclick="Enable()">Enable</button>
        </p>
    <% } %>

    <script type="text/javascript">

        function getUpload(){
            return $("#attachments").data("tUpload");
        }

        function Disable() {
            getUpload().disable();
        }
        
        function Enable() {
            getUpload().enable();
        }

    </script>

</asp:Content>

<asp:Content ID="Content1" contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .configurator p
        {
            margin: 0;
        }
    </style>
</asp:Content>