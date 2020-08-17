namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Fluent;
    using Xunit;

    public class ChartBarSeriesBuilderTests
    {
        private readonly ChartBarSeries<SalesData, decimal> series;
        private readonly ChartBarSeriesBuilder<SalesData> builder;

        public ChartBarSeriesBuilderTests()
        {
            var chart = ChartTestHelper.CreateChart<SalesData>();
            series = new ChartBarSeries<SalesData, decimal>(chart, s => s.RepSales);
            builder = new ChartBarSeriesBuilder<SalesData>(series);
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
        public void Stack_should_set_Stacked()
        {
            builder.Stack(true);
            series.Stacked.ShouldBeTrue();
        }

        [Fact]
        public void Gap_should_set_gap()
        {
            builder.Gap(1);
            series.Gap.ShouldEqual(1);
        }

        [Fact]
        public void Spacing_should_set_spacing()
        {
            builder.Spacing(1);
            series.Spacing.ShouldEqual(1);
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
        public void Border_sets_width_and_color()
        {
            builder.Border(1, "red", ChartDashType.Dot);
            series.Border.Color.ShouldEqual("red");
            series.Border.Width.ShouldEqual(1);
            series.Border.DashType.ShouldEqual(ChartDashType.Dot);
        }

        [Fact]
        public void Color_should_set_color()
        {
            builder.Color("Blue");
            series.Color.ShouldEqual("Blue");
        }

        [Fact]
        public void Overlay_should_set_overlay()
        {
            builder.Overlay(ChartBarSeriesOverlay.None);
            series.Overlay.ShouldEqual(ChartBarSeriesOverlay.None);
        }

        [Fact]
        public void Overlay_should_return_builder()
        {
            builder.Overlay(ChartBarSeriesOverlay.None).ShouldBeSameAs(builder);
        }
    }
}