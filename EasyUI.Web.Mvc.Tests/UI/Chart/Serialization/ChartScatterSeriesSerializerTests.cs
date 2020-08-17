namespace EasyUI.Web.Mvc.UI.Tests
{
    using System.Collections;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI.Tests.Chart;
    using Xunit;

    public class ChartScatterSeriesSerializerTests
    {
        private readonly ChartScatterSeries<XYData, float> scatterSeries;

        public ChartScatterSeriesSerializerTests()
        {
            var chart = ChartTestHelper.CreateChart<XYData>();
            chart.DataSource = XYDataBuilder.GetCollection();
            scatterSeries = new ChartScatterSeries<XYData, float>(chart, s => s.X, s => s.Y);
        }

        [Fact]
        public void Serializes_type()
        {
            GetJson(scatterSeries)["type"].ShouldEqual("scatter");
        }

        [Fact]
        public void Serializes_name()
        {
            scatterSeries.Name = "Scatter";
            GetJson(scatterSeries)["name"].ShouldEqual("Scatter");
        }

        [Fact]
        public void Should_not_serialize_empty_name()
        {
            scatterSeries.Name = string.Empty;
            GetJson(scatterSeries).ContainsKey("name").ShouldBeFalse();
        }

        [Fact]
        public void Serializes_opacity()
        {
            scatterSeries.Opacity = 0.5;
            GetJson(scatterSeries)["opacity"].ShouldEqual(0.5);
        }

        [Fact]
        public void Should_not_serialize_default_opacity()
        {
            scatterSeries.Opacity = 1;
            GetJson(scatterSeries).ContainsKey("opacity").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_data()
        {
            (GetJson(scatterSeries)["data"] is IEnumerable).ShouldBeTrue();
        }

        [Fact]
        public void Should_serialize_data_as_array_of_arrays()
        {
            foreach (var xyPair in (IEnumerable) GetJson(scatterSeries)["data"])
            {
                ((float[])xyPair).Length.ShouldEqual(2);
            }
        }

        [Fact]
        public void Should_serialize_members_if_has_no_data()
        {
            scatterSeries.Data = null;
            GetJson(scatterSeries)["xField"].ShouldEqual("X");
            GetJson(scatterSeries)["yField"].ShouldEqual("Y");
        }

        [Fact]
        public void Should_serialize_label_settings()
        {
            scatterSeries.Labels.Visible = true;
            GetJson(scatterSeries).ContainsKey("labels").ShouldEqual(true);
        }

        [Fact]
        public void Should_not_serialize_label_settings_by_default()
        {
            GetJson(scatterSeries).ContainsKey("labels").ShouldEqual(false);
        }

        [Fact]
        public void Should_serialize_marker_settings()
        {
            scatterSeries.Markers.Background = "green";
            GetJson(scatterSeries).ContainsKey("markers").ShouldEqual(true);
        }

        [Fact]
        public void Should_not_serialize_marker_settings_by_default()
        {
            GetJson(scatterSeries).ContainsKey("markers").ShouldEqual(false);
        }

        [Fact]
        public void Serializes_color()
        {
            scatterSeries.Color = "Blue";
            GetJson(scatterSeries)["color"].ShouldEqual("Blue");
        }

        [Fact]
        public void Does_not_serialize_default_color()
        {
            GetJson(scatterSeries).ContainsKey("color").ShouldBeFalse();
        }

        private static IDictionary<string, object> GetJson(IChartSeries series)
        {
            return series.CreateSerializer().Serialize();
        }
    }
}
