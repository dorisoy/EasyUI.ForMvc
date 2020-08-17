namespace EasyUI.Web.Mvc.UI.Tests
{
    using System.Collections;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI.Tests.Chart;
    using Xunit;

    public class ChartScatterLineSeriesSerializerTests
    {
        private readonly ChartScatterLineSeries<XYData, float> scatterLineSeries;

        public ChartScatterLineSeriesSerializerTests()
        {
            var chart = ChartTestHelper.CreateChart<XYData>();
            chart.DataSource = XYDataBuilder.GetCollection();
            scatterLineSeries = new ChartScatterLineSeries<XYData, float>(chart, s => s.X, s => s.Y);
        }

        [Fact]
        public void Serializes_type()
        {
            GetJson(scatterLineSeries)["type"].ShouldEqual("scatterLine");
        }

        [Fact]
        public void Serializes_name()
        {
            scatterLineSeries.Name = "Scatter";
            GetJson(scatterLineSeries)["name"].ShouldEqual("Scatter");
        }

        [Fact]
        public void Should_not_serialize_empty_name()
        {
            scatterLineSeries.Name = string.Empty;
            GetJson(scatterLineSeries).ContainsKey("name").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_opacity()
        {
            scatterLineSeries.Opacity = 0.5;
            GetJson(scatterLineSeries)["opacity"].ShouldEqual(0.5);
        }

        [Fact]
        public void Should_not_serialize_default_opacity()
        {
            scatterLineSeries.Opacity = 1;
            GetJson(scatterLineSeries).ContainsKey("opacity").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_width()
        {
            scatterLineSeries.Width = 2;
            GetJson(scatterLineSeries)["width"].ShouldEqual(2.0);
        }

        [Fact]
        public void Should_not_seriale_default_width()
        {
            GetJson(scatterLineSeries).ContainsKey("width").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_DashType()
        {
            scatterLineSeries.DashType = ChartDashType.Dash;
            GetJson(scatterLineSeries)["dashType"].ShouldEqual("dash");
        }

        [Fact]
        public void Should_not_seriale_default_DashType()
        {
            GetJson(scatterLineSeries).ContainsKey("dashType").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_MissingValues()
        {
            scatterLineSeries.MissingValues = ChartScatterLineMissingValues.Interpolate;
            GetJson(scatterLineSeries)["missingValues"].ShouldEqual("interpolate");
        }

        [Fact]
        public void Should_not_seriale_default_MissingValues()
        {
            GetJson(scatterLineSeries).ContainsKey("missingValues").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_data()
        {
            (GetJson(scatterLineSeries)["data"] is IEnumerable).ShouldBeTrue();
        }

        [Fact]
        public void Should_serialize_data_as_array_of_arrays()
        {
            foreach (var xyPair in (IEnumerable)GetJson(scatterLineSeries)["data"])
            {
                ((float[])xyPair).Length.ShouldEqual(2);
            }
        }

        [Fact]
        public void Should_serialize_members_if_has_no_data()
        {
            scatterLineSeries.Data = null;
            GetJson(scatterLineSeries)["xField"].ShouldEqual("X");
            GetJson(scatterLineSeries)["yField"].ShouldEqual("Y");
        }

        [Fact]
        public void Should_serialize_label_settings()
        {
            scatterLineSeries.Labels.Visible = true;
            GetJson(scatterLineSeries).ContainsKey("labels").ShouldEqual(true);
        }

        [Fact]
        public void Should_not_serialize_label_settings_by_default()
        {
            GetJson(scatterLineSeries).ContainsKey("labels").ShouldEqual(false);
        }

        [Fact]
        public void Should_serialize_marker_settings()
        {
            scatterLineSeries.Markers.Background = "green";
            GetJson(scatterLineSeries).ContainsKey("markers").ShouldEqual(true);
        }

        [Fact]
        public void Should_not_serialize_marker_settings_by_default()
        {
            GetJson(scatterLineSeries).ContainsKey("markers").ShouldEqual(false);
        }

        [Fact]
        public void Serializes_color()
        {
            scatterLineSeries.Color = "Blue";
            GetJson(scatterLineSeries)["color"].ShouldEqual("Blue");
        }

        [Fact]
        public void Does_not_serialize_default_color()
        {
            GetJson(scatterLineSeries).ContainsKey("color").ShouldBeFalse();
        }

        private static IDictionary<string, object> GetJson(IChartSeries series)
        {
            return series.CreateSerializer().Serialize();
        }
    }
}
