namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Fluent;
    using Xunit;

    public class ChartValueAxisFactoryTests
    {
        private readonly Chart<SalesData> chart;
        private readonly ChartValueAxisFactory<SalesData> factory;

        public ChartValueAxisFactoryTests()
        {
            chart = ChartTestHelper.CreateChart<SalesData>();
            factory = new ChartValueAxisFactory<SalesData>(chart);
        }

        [Fact]
        public void Numeric_should_create_ChartNumericAxis()
        {
            var builder = factory.Numeric();
            builder.Axis.ShouldBeType<ChartNumericAxis<SalesData>>();
        }
    }
}
