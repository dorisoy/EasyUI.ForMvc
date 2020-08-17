<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <button id="playButton" class="t-button" onclick="playButtonClick()">Start update</button>

    <div class="wrap">
        <div id="fpsCount">-- FPS / (-- ms rendering time)</div>
        <%: Html.EasyUI().Chart()
                .Name("chart")
                .Theme(Html.GetCurrentTheme())
                .Title("Stock prices")
                .Legend(false)
                .Series(series => {
                    series.Column(ViewBag.StockA).Name("Stock A");
                    series.Line(ViewBag.StockB).Name("Stock B");
                    series.Line(ViewBag.StockC).Name("Stock C");
                })
                .CategoryAxis(c => c
                    .Categories(ViewBag.Categories)
                )
                .ValueAxis(axis => axis
                    .Numeric().Labels(labels => labels.Format("${0}"))
                )
                .HtmlAttributes(new { style = "width: 670px; height: 400px;" })
                .Transitions(false)
        %>
    </div>

    <script type="text/javascript">

        var TICKS_PER_DAY = 86400000,
            POINTS = 20,
            SERIES_COUNT = 3,
            lastDate = new Date("2000/01/20"),
            playInterval,
            fpsUpdateInterval;

        function playButtonClick(button) {
            var button = $("#playButton");

            if (playInterval) {
                stop();
                button.text("Start update");
            } else {
                play();
                button.html("Pause update");
            }
        }

        function play() {
            var frames = 0,
                start = new Date();

            playInterval = setInterval(function() {
                step();
                frames++;
            }, 10);

            fpsUpdateInterval = setInterval(function() {
                var time = (new Date() - start) / 1000,
                    fps = Math.round(frames / time),
                    frameTime = Math.round(1000 / fps);

                $("#fpsCount").html(fps + " FPS (" + frameTime + " ms rendering time)");
            }, 1000);
        }

        function stop() {
            clearInterval(playInterval);
            clearInterval(fpsUpdateInterval);

            playInterval = null;
            fpsUpdateInterval = null;
        }

        function step() {
            var chart = $("#chart").data("tChart"),
                options = chart.options,
                categories = options.categoryAxis.categories;

            // Shift existing categories to the left and add the next date at the end
            lastDate = new Date(lastDate.getTime() + TICKS_PER_DAY);
            categories.shift();
            categories.push((lastDate.getMonth() + 1) + "/" + (lastDate.getDay() + 1));
            
            for (var i = 0; i < SERIES_COUNT; i++) {
                // Shift the data points of each series to the left
                var data = options.series[i].data;
                data.shift();

                var change = (Math.random() > 0.5 ? 1 : - 1) * Math.random() * 10;
                var lastValue = data[data.length - 1];

                // Add a new pseudo-random data point
                data.push(Math.min((i + 1) * 20, Math.max((i + 1) * 10, lastValue + change)));
            }

            // Refresh the chart
            // Note that we use refresh when manually updating the data points
            chart.refresh();
        }

    </script>


</asp:Content>

<asp:Content ID="Content1" contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .wrap {
            position: relative;
            width: 670px;
            margin: auto;
        }
        
        #fpsCount {
            position: absolute;
            left: 487px;
            top: 14px;
            z-index: 1;
            background: #777;
            color: #fff;
            padding: 5px;
            white-space: nowrap;
        }
    </style>
</asp:Content>