<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<SalesData>>" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <%: Html.EasyUI().Chart<SalesData>()
            .Name("chartAjax")
            .Theme(Html.GetCurrentTheme())
            .Title("Representative Sales vs. Total Sales")
            .Legend(legend => legend
                .Position(ChartLegendPosition.Bottom)
            )
            .SeriesDefaults(series =>
                series.Bar().Labels(labels => labels.Visible(true).Format("${0:#,##0}"))
            )
            .Series(series => {
                series.Bar("RepSales").Name("Representative Sales");
                series.Bar(s => s.TotalSales).Name("Total Sales")
                    .Labels(labels => labels
                        .Position(ChartBarLabelsPosition.InsideEnd)
                    );
            })
            .CategoryAxis(axis => axis
                .Categories(s => s.DateString)
            )
            .ValueAxis(axis => axis
                .Numeric().Labels(labels => labels.Format("${0:#,##0}"))
            )
            .DataBinding(dataBinding => dataBinding
                .Ajax().Select("_SalesData", "Chart")
            )
            .HtmlAttributes(new { style = "width: 670px; height: 500px;" })
    %>

</asp:Content>
