<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <%  Html.EasyUI().Splitter().Name("Splitter1")
            .Panes(panes =>
            {
                panes.Add()
                    .Size("200px")
                    .Collapsible(true)
                    .Content(() =>
                    {%>
                        <div style="padding: 0 2em; text-align: center">
                            <p>Static sidebar content</p>
                            <p>Right pane is loaded after the page loads</p>
                        </div>
                    <%});

                panes.Add()
                    .LoadContentFrom("AjaxView_Grid", "Splitter");
            })
            .Render();
    %>

    <% Html.EasyUI().ScriptRegistrar()
           .DefaultGroup(group => group
               .Add("easyui.common.js")
               .Add("easyui.draganddrop.js")
               .Add("easyui.grid.js")
               .Add("easyui.grid.grouping.js")
            ); %>

</asp:Content>
