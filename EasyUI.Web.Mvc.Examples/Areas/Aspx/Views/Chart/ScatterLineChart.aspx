<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Point[]>>" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">
    <%: Html.EasyUI().Chart(Model)
            .Name("chart")
            .Theme(Html.GetCurrentTheme())
            .Legend(false)
            .Series(series => {
                series.ScatterLine(p => p[0].X, p => p[0].Y);
                series.ScatterLine(p => p[1].X, p => p[1].Y);
                series.ScatterLine(p => p[2].X, p => p[2].Y);
            })
            .SeriesDefaults(series => series.ScatterLine().Width(2).Markers(false))
            .XAxis(x => x.AxisCrossingValue(-1.5))
            .YAxis(y => y.MajorUnit(10))
            .AxisDefaults(a => a
                .MajorGridLines(mg => mg.Visible(false))
            )
            .HtmlAttributes(new { style = "width: 500px; height: 400px; margin: auto;" })
    %>
</asp:Content>

<asp:Content contentPlaceHolderID="HeadContent" runat="server">
</asp:Content>