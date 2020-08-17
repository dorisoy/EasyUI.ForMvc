namespace EasyUI.Web.Mvc.UI.Tests
{
    using Xunit;
    using System.Collections;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI.Tests.Chart;
    using System.Linq;

    public class ChartPieSeriesSerializerTests
    {
        private readonly ChartPieSeries<SalesData, decimal> pieSeries;

        public ChartPieSeriesSerializerTests()
        {
            var chart = ChartTestHelper.CreateChart<SalesData>();
            chart.DataSource = SalesDataBuilder.GetCollection();
            pieSeries = new ChartPieSeries<SalesData, decimal>(chart, s => s.RepSales, s => s.RepName, s => s.Color, s => s.Explode);
        }

        [Fact]
        public void Serializes_type()
        {
            GetJson(pieSeries)["type"].ShouldEqual("pie");
        }

        [Fact]
        public void Serializes_name()
        {
            pieSeries.Name = "Pie";
            GetJson(pieSeries)["name"].ShouldEqual("Pie");
        }

        [Fact]
        public void Should_not_serialize_empty_name()
        {
            pieSeries.Name = string.Empty;
            GetJson(pieSeries).ContainsKey("name").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_opacity()
        {
            pieSeries.Opacity = 0.5;
            GetJson(pieSeries)["opacity"].ShouldEqual(0.5);
        }

        [Fact]
        public void Should_not_serialize_default_opacity()
        {
            pieSeries.Opacity = 1;
            GetJson(pieSeries).ContainsKey("opacity").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_padding()
        {
            pieSeries.Padding = 80;
            GetJson(pieSeries)["padding"].ShouldEqual(80);
        }

        [Fact]
        public void Should_not_serialize_default_padding()
        {
            GetJson(pieSeries).ContainsKey("padding").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_StartAngle()
        {
            pieSeries.StartAngle = 2;
            GetJson(pieSeries)["startAngle"].ShouldEqual(2);
        }

        [Fact]
        public void Should_not_serialize_default_width()
        {
            GetJson(pieSeries).ContainsKey("startAngle").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_data()
        {
            (GetJson(pieSeries)["data"] is IEnumerable).ShouldBeTrue();
        }

        [Fact]
        public void Should_serialize_data_with_dataItems()
        {
            var data = (GetJson(pieSeries)["data"] as List<IDictionary<string, object>>).First();
            data["value"].ShouldEqual(2015M);
            data["category"].ShouldEqual("Nancy Davolio");
            data["explode"].ShouldEqual(true);
            data["color"].ShouldEqual("red");
        }

        [Fact]
        public void Should_serialize_member_if_has_no_data()
        {
            pieSeries.Data = null;
            GetJson(pieSeries)["field"].ShouldEqual("RepSales");
        }

        [Fact]
        public void Should_serialize_category_member_if_has_no_data()
        {
            pieSeries.Data = null;
            GetJson(pieSeries)["categoryField"].ShouldEqual("RepName");
        }

        [Fact]
        public void Should_serialize_color_member_if_has_no_data()
        {
            pieSeries.Data = null;
            GetJson(pieSeries)["colorField"].ShouldEqual("Color");
        }

        [Fact]
        public void Should_serialize_explode_member_if_has_no_data()
        {
            pieSeries.Data = null;
            GetJson(pieSeries)["explodeField"].ShouldEqual("Explode");
        }

        [Fact]
        public void Should_serialize_label_settings()
        {
            pieSeries.Labels.Visible = true;
            GetJson(pieSeries).ContainsKey("labels").ShouldEqual(true);
        }

        [Fact]
        public void Should_not_serialize_label_settings_by_default()
        {
            GetJson(pieSeries).ContainsKey("labels").ShouldEqual(false);
        }

        [Fact]
        public void Does_not_serialize_default_color()
        {
            GetJson(pieSeries).ContainsKey("color").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_overlay()
        {
            pieSeries.Overlay = ChartPieSeriesOverlay.None;
            GetJson(pieSeries).ContainsKey("overlay").ShouldBeTrue();
        }

        [Fact]
        public void Should_not_serialize_default_overlay()
        {
            GetJson(pieSeries).ContainsKey("overlay").ShouldBeFalse();
        }

        private static IDictionary<string, object> GetJson(IChartSeries series)
        {
            return series.CreateSerializer().Serialize();
        }
    }
}