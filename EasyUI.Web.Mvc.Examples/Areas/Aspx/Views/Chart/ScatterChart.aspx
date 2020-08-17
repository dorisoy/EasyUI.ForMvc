<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Point>>" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">
    <%: Html.EasyUI().Chart(Model)
            .Name("chart")
            .Theme(Html.GetCurrentTheme())
            .Legend(false)
            .Series(series => {
                series.Scatter("X", "Y").Markers(markers => markers.Size(5));
            })
            .XAxis(x => x.AxisCrossingValue(-20))
            .YAxis(y => y.AxisCrossingValue(-20))
            .HtmlAttributes(new { style = "width: 500px; height: 400px; margin: auto;" })
    %>
</asp:Content>

<asp:Content contentPlaceHolderID="HeadContent" runat="server">
</asp:Content>