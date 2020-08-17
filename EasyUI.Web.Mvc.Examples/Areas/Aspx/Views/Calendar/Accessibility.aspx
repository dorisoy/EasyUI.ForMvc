<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>


<asp:content contentPlaceHolderID="MainContent" runat="server">
    <%: Html.EasyUI().Calendar()
            .Name("Calendar")
            .Selection(settings => settings
                .Action("Accessibility", new { date = "{0}", theme = Request.QueryString["theme"] }))
            .Value((DateTime)ViewData["date"])
    %>

    <noscript>
        <p>Your browsing experience on this page will be better if you visit it with a JavaScript-enabled browser / if you enable JavaScript.</p>
    </noscript>
    
    <% Html.RenderPartial("AccessibilityValidation"); %>
</asp:content>