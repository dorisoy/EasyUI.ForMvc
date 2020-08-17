<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">

    <% Html.EasyUI().Window()
           .Name("Window")
           .Title("EasyUI Window for ASP.NET MVC")
           .Content(() =>
           {%>
                <p style="text-align: center">
                    <img src="<%: Url.Content("~/Content/Window/window.png")%>"
                         alt="Window for ASP.NET MVC logo" style="display:block;margin:0 auto 10px;" />
                            
                    The EasyUI Window for ASP.NET MVC is<br /> the right choice for creating Window dialogs<br />
                    and alert/prompt/confirm boxes<br /> in your ASP.NET MVC applications.
                </p>
           <%})
           .Width(300)
           .Height(300)
           .Render();
    %>

    <noscript>
        <p>Your browsing experience on this page will be better if you visit it with a JavaScript-enabled browser / if you enable JavaScript.</p>
    </noscript>

    <% Html.RenderPartial("AccessibilityValidation"); %>
</asp:content>

<asp:content ID="Content1" contentplaceholderid="HeadContent" runat="server">
    <style type="text/css">
        
        .accessibility-validation
        {
            margin-top: 370px;
        }
        
        #undo
        {
            text-align: center;
            position: absolute;
            white-space: nowrap;
            border-width: 1px;
            border-style: solid;
            padding: 2em;
            cursor: pointer;
        }
    </style>
</asp:content>