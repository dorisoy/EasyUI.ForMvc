<%@ Page Title="ClientAPI tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <h2>Configuration Tests</h2>

    <%= Html.EasyUI().Chart<object>().Name("dummyChart") %>

    <div id="chart"></div>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    function createChart(options) {
        $("#chart").tChart(options);
        return $("#chart").data("tChart");
    }

    module("Wrapper", {
        setup: function() {
            $("#chart").data("tChart", null);
        }
    });

    test("Wraps chart implementation", function() {
        var chart = createChart();
        ok(chart._chart != null);
    });

    test("Sets title", function() {
        var chart = createChart({ title: { text: "Chart" } });
        equal(chart._chart.options.title.text, "Chart");
    });

    test("Sets series", function() {
        var chart = createChart({ title: "Chart", series: [{ type: "bar" }] });
        equal(chart._chart.options.series.length, 1);
    });

    test("Sets category axis configuration", function() {
        var chart = createChart({ title: "Chart", categoryAxis: { categories: ["A", "B"] } });
        equal(chart._chart.options.categoryAxis.categories.length, 2);
    });

    test("Sets category datasource configuration", function() {
        var chart = createChart({ title: "Chart", dataSource: { transport: { read: "A" } } });
        equal(chart._chart.options.dataSource.transport.read, "A");
    });

    test("Refresh updates chart options", function() {
        var chart = createChart({ title: { text: "Chart" } });
        chart.options.title.text = "New Chart";
        chart.refresh();

        equal(chart._chart.options.title.text, "New Chart");        
    });

</script>

</asp:Content>