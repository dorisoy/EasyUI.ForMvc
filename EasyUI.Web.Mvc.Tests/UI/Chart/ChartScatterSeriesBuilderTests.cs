namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Fluent;
    using Xunit;

    public class ChartScatterSeriesBuilderTests
    {
        private readonly ChartScatterSeries<XYData, float> series;
        private readonly ChartScatterSeriesBuilder<XYData> builder;

        public ChartScatterSeriesBuilderTests()
        {
            var chart = ChartTestHelper.CreateChart<XYData>();
            series = new ChartScatterSeries<XYData, float>(chart, s => s.X, s => s.Y);
            builder = new ChartScatterSeriesBuilder<XYData>(series);
        }

        [Fact]
        public void Name_should_set_name()
        {
            builder.Name("Series");
            series.Name.ShouldEqual("Series");
        }

        [Fact]
        public void Opacity_should_set_opacity()
        {
            builder.Opacity(0.5);
            series.Opacity.ShouldEqual(0.5);
        }

        [Fact]
        public void Opacity_should_return_builder()
        {
            builder.Opacity(0.5).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Labels_should_set_labels_visibility()
        {
            builder.Labels(true);
            series.Labels.Visible.ShouldEqual(true);
        }

        [Fact]
        public void Labels_should_return_builder()
        {
            builder.Labels(labels => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Markers_should_set_markers_visibility()
        {
            builder.Markers(true);
            series.Markers.Visible.ShouldEqual(true);
        }

        [Fact]
        public void Markers_should_return_builder()
        {
            builder.Markers(labels => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Color_should_set_color()
        {
            builder.Color("Blue");
            series.Color.ShouldEqual("Blue");
        }
    }
}