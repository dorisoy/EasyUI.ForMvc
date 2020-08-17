<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">

    <div class="t-rtl" style="float: left;width:310px;">
        <% Html.EasyUI().Window()
               .Name("Window")
               .Title("EasyUI Window for ASP.NET MVC")
               .Draggable(true)
               .Resizable()
               .Buttons(b => b.Maximize().Close())
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
    </div>
    
    <% Html.EasyUI().ScriptRegistrar()
           .OnDocumentReady(() => {%>
                var windowElement = $('#Window');
                var undoButton = $('#undo');
                undoButton
                    .bind('click', function(e) {
                        windowElement.data('tWindow').open();
                        undoButton.hide();
                    })
                    .toggle(!windowElement.is(':visible'));
                
                windowElement.bind('close', function() {
                    undoButton.show();
                });
           <%}); %>
           
    <span id="undo" class="t-group">Click here to open the window.</span>
           

</asp:content>

<asp:content contentplaceholderid="HeadContent" runat="server">
    <style type="text/css">
        
        .example
        {
            height: 340px;
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