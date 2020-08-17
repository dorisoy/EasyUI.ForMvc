<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">
    <h3>Horizontal</h3>
    
    <%  Html.EasyUI().Splitter().Name("Splitter1")
            .Panes(panes =>
            {
                panes.Add()
                    .Size("100px")
                    .MinSize("40px")
                    .MaxSize("150px")
                    .Collapsible(true)
                    .Content(() =>
                    {%>
                        <p>Left pane</p>
                    <%});

                panes.Add()
                    .Content(() =>
                    {%>
                        <p>Center pane</p>
                    <%});

                panes.Add()
                    .Size("20%")
                    .Collapsible(true)
                    .Content(() =>
                    {%>
                        <p>Right pane</p>
                    <%});
            })
            .Render();
    %>

    <h3>Vertical</h3>

    <%  Html.EasyUI().Splitter().Name("Splitter2")
            .Orientation(SplitterOrientation.Vertical)
            .Panes(panes =>
            {
                panes.Add()
                    .Size("100px")
                    .MinSize("40px")
                    .MaxSize("150px")
                    .Collapsible(true)
                    .Content(() =>
                    {%>
                        <p>Top pane</p>
                    <%});

                panes.Add()
                    .Content(() =>
                    {%>
                        <p>Center pane</p>
                    <%});

                panes.Add()
                    .Size("20%")
                    .Collapsible(true)
                    .Content(() =>
                    {%>
                        <p>Bottom pane</p>
                    <%});
            })
            .Render();
    %>

</asp:Content>
