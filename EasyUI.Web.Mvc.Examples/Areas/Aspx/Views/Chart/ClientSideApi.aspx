<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <%: Html.EasyUI().Chart<SalesData>()
            .Name("chart")
            .Theme(Html.GetCurrentTheme())
            .Title("Representative Sales vs. Total Sales")
            .Legend(legend => legend
                .Position(ChartLegendPosition.Top)
            )
            .Series(series => {
                series.Column(s => s.RepSales).Name("Representative Sales");
                series.Column(s => s.TotalSales).Name("Total Sales");
            })
            .CategoryAxis(axis => axis
                .Categories(s => s.DateString)
                .Labels(labels => labels.Rotation(-45))
            )
            .ValueAxis(axis => axis
                .Numeric().Labels(labels => labels.Format("${0:#,##0}"))
            )
            .DataBinding(dataBinding => dataBinding
                .Ajax().Select("_SalesDataByYear", "Chart")
            )    
            .Tooltip(tooltip => tooltip
                .Visible(true)
                .Format("${0:#,##0}")
            )        
            .HtmlAttributes(new { style = "width: 670px; height: 400px;" })
    %>

    <% using (Html.Configurator("Client API").Begin()) { %>
        <ul>
            <li>
                <label for="year">Year: </label>
                <%: Html.EasyUI().DropDownList()
                            .Name("year")
                            .HtmlAttributes(new { style = "width: 60px;" })
                            .Items(items =>
                            {
                                items.Add().Text("2010")
                                    .Value("2010")
                                    .Selected(ViewBag.Year == "2010");

                                items.Add().Text("2011")
                                    .Value("2011")
                                    .Selected(ViewBag.Year == "2011");
                            })
                %>
                <button class="t-button" onclick="rebind()">rebind</button>
            </li>
            <li>
                <button class="t-button" onclick="refresh()">refresh</button> chart
            </li>
        </ul>
    <% } %>

    <script type="text/javascript">

        function getChart(){
            return $("#chart").data("tChart");
        }

        function refresh() {
            getChart().refresh();
        }

        function rebind() {
            getChart().rebind({ year: $("#year").val() });
        }

    </script>


</asp:Content>

<asp:Content ID="Content1" contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .configurator p
        {
            margin: 0;
        }
        
        .example .configurator {
            float: right;
            width: 170px;
            margin: 0 0 0 0;
            display: inline;
        }
        
        .t-chart {
            float: left;
        }
    </style>
</asp:Content>