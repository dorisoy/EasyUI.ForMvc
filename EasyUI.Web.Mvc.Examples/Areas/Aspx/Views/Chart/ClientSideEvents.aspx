<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<SalesData>>" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function onLoad(e) {
            $console.log("Chart loaded");
        }

        function onDataBound(e) {
            $console.log("Chart data bound");
        }

        function onSeriesClick(e) {
            $console.log("Series clicked: " + e.series.name + " (" + e.category  + "): " + e.value);
        }
    </script>

    <%: Html.EasyUI().Chart<SalesData>()
            .Name("chart")
            .Theme(Html.GetCurrentTheme())
            .Title("Representative Sales vs. Total Sales")
            .Legend(legend => legend
                .Position(ChartLegendPosition.Bottom)
            )
            .Series(series => {
                series.Bar(s => s.RepSales).Name("Representative Sales");
                series.Bar(s => s.TotalSales).Name("Total Sales");
            })
            .CategoryAxis(axis => axis
                .Categories(s => s.DateString)
            )
            .DataBinding(dataBinding => dataBinding
                .Ajax().Select("_SalesData", "Chart")
            )
            .ValueAxis(axis => axis
                .Numeric().Labels(labels => labels.Format("${0:#,##0}"))
            )
            .ClientEvents(events => events
                .OnLoad("onLoad")
                .OnDataBound("onDataBound")
                .OnSeriesClick("onSeriesClick")
            )
            .Tooltip(tooltip => tooltip
                .Visible(true)
                .Format("${0:#,##0}")
            )
            .HtmlAttributes(new { style = "width: 670px; height: 400px; margin-bottom: 4em;" })
    %>

    <% Html.RenderPartial("EventLog"); %>

</asp:Content>
