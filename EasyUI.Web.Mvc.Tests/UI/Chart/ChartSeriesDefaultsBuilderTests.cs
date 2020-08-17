namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Fluent;
    using Xunit;

    public class ChartSeriesDefaultsBuilderTests
    {
        private readonly Chart<object> chart;
        private readonly ChartSeriesDefaultsBuilder<object> builder;

        public ChartSeriesDefaultsBuilderTests()
        {
            chart = ChartTestHelper.CreateChart<object>();
            builder = new ChartSeriesDefaultsBuilder<object>(chart);
        }

        [Fact]
        public void Bar_sets_BarSeries_options()
        {
            builder.Bar().Gap(4);
            chart.SeriesDefaults.Bar.Gap.ShouldEqual(4);
        }

        [Fact]
        public void Column_sets_ColumnSeries_options()
        {
            builder.Column().Gap(4);
            chart.SeriesDefaults.Column.Gap.ShouldEqual(4);
        }

        [Fact]
        public void Line_sets_LineSeries_options()
        {
            builder.Line().Width(4);
            chart.SeriesDefaults.Line.Width.ShouldEqual(4);
        }

        [Fact]
        public void Scatter_sets_ScatterSeries_options()
        {
            builder.Scatter().Opacity(.5);
            chart.SeriesDefaults.Scatter.Opacity.ShouldEqual(0.5);
        }

        [Fact]
        public void ScatterLine_sets_ScatterLineSeries_options()
        {
            builder.ScatterLine().Opacity(.5);
            chart.SeriesDefaults.ScatterLine.Opacity.ShouldEqual(0.5);
        }
    }
}