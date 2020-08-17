namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Fluent;
    using Xunit;

    public class ChartNumericAxisBuilderTests
    {
        private readonly ChartNumericAxis<SalesData> axis;
        private readonly ChartNumericAxisBuilder builder;

        public ChartNumericAxisBuilderTests()
        {
            var chart = ChartTestHelper.CreateChart<SalesData>();
            axis = new ChartNumericAxis<SalesData>(chart);
            builder = new ChartNumericAxisBuilder(axis);
        }

        [Fact]
        public void Min_should_set_Min()
        {
            builder.Min(10);
            axis.Min.ShouldEqual(10);
        }

        [Fact]
        public void Min_should_return_builder()
        {
            builder.Min(10).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Max_should_set_Max()
        {
            builder.Max(10);
            axis.Max.ShouldEqual(10);
        }

        [Fact]
        public void Max_should_return_builder()
        {
            builder.Max(10).ShouldBeSameAs(builder);
        }

        [Fact]
        public void MajorUnit_should_set_MajorUnit()
        {
            builder.MajorUnit(10);
            axis.MajorUnit.ShouldEqual(10);
        }

        [Fact]
        public void MajorUnit_should_return_builder()
        {
            builder.MajorUnit(10).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Labels_should_set_Labels()
        {
            builder.Labels(true);
            axis.Labels.Visible.ShouldEqual(true);
        }

        [Fact]
        public void Labels_should_return_builder()
        {
            builder.Labels(true).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Orientation_should_set_Orientation()
        {
            builder.Orientation(ChartAxisOrientation.Vertical);
            axis.Orientation.ShouldEqual(ChartAxisOrientation.Vertical);
        }

        [Fact]
        public void Orientation_should_return_builder()
        {
            builder.Orientation(ChartAxisOrientation.Vertical).ShouldBeSameAs(builder);
        }
    }
}