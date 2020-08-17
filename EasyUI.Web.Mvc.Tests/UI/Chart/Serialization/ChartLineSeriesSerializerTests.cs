namespace EasyUI.Web.Mvc.UI.Tests
{
    using System.Collections;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI.Tests.Chart;
    using Xunit;

    public class ChartLineSeriesSerializerTests
    {
        private readonly ChartLineSeries<SalesData, decimal> lineSeries;

        public ChartLineSeriesSerializerTests()
        {
            var chart = ChartTestHelper.CreateChart<SalesData>();
            chart.DataSource = SalesDataBuilder.GetCollection();
            lineSeries = new ChartLineSeries<SalesData, decimal>(chart, s => s.RepSales);
        }

        [Fact]
        public void Serializes_type()
        {
            GetJson(lineSeries)["type"].ShouldEqual("line");
        }

        [Fact]
        public void Serializes_name()
        {
            lineSeries.Name = "Line";
            GetJson(lineSeries)["name"].ShouldEqual("Line");
        }

        [Fact]
        public void Should_not_serialize_empty_name()
        {
            lineSeries.Name = string.Empty;
            GetJson(lineSeries).ContainsKey("name").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_opacity()
        {
            lineSeries.Opacity = 0.5;
            GetJson(lineSeries)["opacity"].ShouldEqual(0.5);
        }

        [Fact]
        public void Should_not_serialize_default_opacity()
        {
            lineSeries.Opacity = 1;
            GetJson(lineSeries).ContainsKey("opacity").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_stack()
        {
            lineSeries.Stacked = true;
            GetJson(lineSeries)["stack"].ShouldEqual(true);
        }

        [Fact]
        public void Should_not_seriale_default_stack()
        {
            GetJson(lineSeries).ContainsKey("stack").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_width()
        {
            lineSeries.Width = 2;
            GetJson(lineSeries)["width"].ShouldEqual(2.0);
        }

        [Fact]
        public void Should_not_seriale_default_width()
        {
            GetJson(lineSeries).ContainsKey("width").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_data()
        {
            (GetJson(lineSeries)["data"] is IEnumerable).ShouldBeTrue();
        }

        [Fact]
        public void Should_serialize_member_if_has_no_data()
        {
            lineSeries.Data = null;
            GetJson(lineSeries)["field"].ShouldEqual("RepSales");
        }

        [Fact]
        public void Should_serialize_label_settings()
        {
            lineSeries.Labels.Visible = true;
            GetJson(lineSeries).ContainsKey("labels").ShouldEqual(true);
        }

        [Fact]
        public void Should_not_serialize_label_settings_by_default()
        {
            GetJson(lineSeries).ContainsKey("labels").ShouldEqual(false);
        }

        [Fact]
        public void Should_serialize_marker_settings()
        {
            lineSeries.Markers.Background = "green";
            GetJson(lineSeries).ContainsKey("markers").ShouldEqual(true);
        }

        [Fact]
        public void Should_not_serialize_marker_settings_by_default()
        {
            GetJson(lineSeries).ContainsKey("markers").ShouldEqual(false);
        }

        [Fact]
        public void Serializes_color()
        {
            lineSeries.Color = "Blue";
            GetJson(lineSeries)["color"].ShouldEqual("Blue");
        }

        [Fact]
        public void Does_not_serialize_default_color()
        {
            GetJson(lineSeries).ContainsKey("color").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_DashType()
        {
            lineSeries.DashType = ChartDashType.Dash;
            GetJson(lineSeries)["dashType"].ShouldEqual("dash");
        }

        [Fact]
        public void Should_not_seriale_default_DashType()
        {
            GetJson(lineSeries).ContainsKey("dashType").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_MissingValues()
        {
            lineSeries.MissingValues = ChartLineMissingValues.Interpolate;
            GetJson(lineSeries)["missingValues"].ShouldEqual("interpolate");
        }

        [Fact]
        public void Should_not_seriale_default_MissingValues()
        {
            GetJson(lineSeries).ContainsKey("missingValues").ShouldBeFalse();
        }

        private static IDictionary<string, object> GetJson(IChartSeries series)
        {
            return series.CreateSerializer().Serialize();
        }
    }
}
