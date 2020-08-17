namespace EasyUI.Web.Mvc.UI.Tests
{
    using System.Collections;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI.Tests.Chart;
    using Xunit;

    public class ChartBarSeriesSerializerTests
    {
        private readonly ChartBarSeries<SalesData, decimal> barSeries;

        public ChartBarSeriesSerializerTests()
        {
            var chart = ChartTestHelper.CreateChart<SalesData>();
            chart.DataSource = SalesDataBuilder.GetCollection();
            barSeries = new ChartBarSeries<SalesData, decimal>(chart, s => s.RepSales);
        }

        [Fact]
        public void Bar_serializes_type()
        {
            GetJson(barSeries)["type"].ShouldEqual("bar");
        }

        [Fact]
        public void Bar_serializes_type_for_vertical_orientation()
        {
            barSeries.Orientation = ChartBarSeriesOrientation.Vertical;
            GetJson(barSeries)["type"].ShouldEqual("column");
        }

        [Fact]
        public void Bar_serializes_name()
        {
            barSeries.Name = "Bar";
            GetJson(barSeries)["name"].ShouldEqual("Bar");
        }

        [Fact]
        public void Bar_should_not_serialize_empty_name()
        {
            barSeries.Name = string.Empty;
            GetJson(barSeries).ContainsKey("name").ShouldBeFalse();
        }

        [Fact]
        public void Bar_serializes_opacity()
        {
            barSeries.Opacity = 0.5;
            GetJson(barSeries)["opacity"].ShouldEqual(0.5);
        }

        [Fact]
        public void Bar_should_not_serialize_default_opacity()
        {
            barSeries.Opacity = 1;
            GetJson(barSeries).ContainsKey("opacity").ShouldBeFalse();
        }

        [Fact]
        public void Bar_serializes_stack()
        {
            barSeries.Stacked = true;
            GetJson(barSeries)["stack"].ShouldEqual(true);
        }

        [Fact]
        public void Bar_should_not_seriale_default_stack()
        {
            GetJson(barSeries).ContainsKey("stack").ShouldBeFalse();
        }

        [Fact]
        public void Bar_serializes_gap()
        {
            barSeries.Gap = 1;
            GetJson(barSeries)["gap"].ShouldEqual(1.0);
        }

        [Fact]
        public void Bar_should_not_seriale_default_gap()
        {
            GetJson(barSeries).ContainsKey("gap").ShouldBeFalse();
        }

        [Fact]
        public void Spacing_serializes_spacing()
        {
            barSeries.Spacing = 1;
            GetJson(barSeries)["spacing"].ShouldEqual(1.0);
        }

        [Fact]
        public void Spacing_should_not_seriale_default_spacing()
        {
            GetJson(barSeries).ContainsKey("spacing").ShouldBeFalse();
        }

        [Fact]
        public void Bar_should_serialize_data()
        {
            (GetJson(barSeries)["data"] is IEnumerable).ShouldBeTrue();
        }

        [Fact]
        public void Bar_should_serialize_member_if_has_no_data()
        {
            barSeries.Data = null;
            GetJson(barSeries)["field"].ShouldEqual("RepSales");
        }

        [Fact]
        public void Bar_should_serialize_label_settings()
        {
            barSeries.Labels.Visible = true;
            GetJson(barSeries).ContainsKey("labels").ShouldEqual(true);
        }

        [Fact]
        public void Bar_should_not_serialize_label_settings_by_default()
        {
            GetJson(barSeries).ContainsKey("labels").ShouldEqual(false);
        }

        [Fact]
        public void Serializes_border()
        {
            barSeries.Border.Color = "red";
            barSeries.Border.Width = 1;
            barSeries.Border.DashType = ChartDashType.Dot;
            ((Dictionary<string, object>)GetJson(barSeries)["border"])["width"].ShouldEqual(1);
            ((Dictionary<string, object>)GetJson(barSeries)["border"])["color"].ShouldEqual("red");
            ((Dictionary<string, object>)GetJson(barSeries)["border"])["dashType"].ShouldEqual("dot");
        }

        [Fact]
        public void Does_not_serialize_default_border()
        {
            GetJson(barSeries).ContainsKey("border").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_color()
        {
            barSeries.Color = "Blue";
            GetJson(barSeries)["color"].ShouldEqual("Blue");
        }

        [Fact]
        public void Does_not_serialize_default_color()
        {
            GetJson(barSeries).ContainsKey("color").ShouldBeFalse();
        }

        [Fact]
        public void Bar_serializes_overlay()
        {
            barSeries.Overlay = ChartBarSeriesOverlay.None;
            GetJson(barSeries).ContainsKey("overlay").ShouldBeTrue();
        }

        [Fact]
        public void Bar_should_not_serialize_default_overlay()
        {
            barSeries.Overlay = ChartBarSeriesOverlay.Glass;
            GetJson(barSeries).ContainsKey("overlay").ShouldBeFalse();
        }

        private static IDictionary<string, object> GetJson(IChartSeries series)
        {
            return series.CreateSerializer().Serialize();
        }
    }
}