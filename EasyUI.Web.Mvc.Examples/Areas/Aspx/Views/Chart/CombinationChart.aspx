<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<SalesData>>" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <%: Html.EasyUI().Chart(Model)
            .Name("chart")
            .Theme(Html.GetCurrentTheme())
            .Title("Representative Sales vs. Total Sales")
            .Legend(legend => legend
                .Position(ChartLegendPosition.Bottom)
            )
            .Series(series => {
                series.Column(s => s.RepSales).Name("Representative Sales");
                series.Line(s => s.TotalSales).Name("Total Sales")
                    .Labels(true).Labels(labels => labels.Format("${0:#,##0}"));
            })
            .CategoryAxis(axis => axis
                .Categories(s => s.DateString)
            )        
            .ValueAxis(axis => axis
                .Numeric().Labels(labels => labels.Format("${0:#,##0}"))
            )
            .HtmlAttributes(new { style = "width: 670px; height: 400px;" })
    %>

</asp:Content>
