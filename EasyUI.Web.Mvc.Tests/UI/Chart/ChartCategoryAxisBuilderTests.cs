namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Fluent;
    using Xunit;

    public class ChartCategoryAxisBuilderTests
    {
        private readonly ChartCategoryAxis<SalesData> axis;
        private readonly ChartCategoryAxisBuilder<SalesData> builder;

        public ChartCategoryAxisBuilderTests()
        {
            var chart = ChartTestHelper.CreateChart<SalesData>();
            axis = new ChartCategoryAxis<SalesData>(chart);
            chart.CategoryAxis = axis;
            builder = new ChartCategoryAxisBuilder<SalesData>(chart);
        }

        [Fact]
        public void Categories_should_bind_categories_with_expression()
        {
            builder.Categories(s => s.DateString);

            var expectedCategories = new Queue<string>();
            expectedCategories.Enqueue("Aug 2010");
            expectedCategories.Enqueue("Sept 2010");

            var categoryStrings = new List<string>();
            foreach (object category in categoryStrings)
            {
                expectedCategories.Dequeue().ShouldEqual(category.ToString());
            }
        }

        [Fact]
        public void Categories_should_set_categories_from_IEnumerable()
        {
            var categories = new string[] { "Aug 2010", "Sept 2010" };

            builder.Categories(categories);

            axis.Categories.ShouldBeSameAs(categories);
        }

        [Fact]
        public void Categories_should_set_categories_from_list()
        {
            builder.Categories("Aug 2010", "Sept 2010");

            AssertCategories(new string[] { "Aug 2010", "Sept 2010" });
        }

        [Fact]
        public void MajorGridLines_should_return_builder()
        {
            builder.MajorGridLines(lines => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void MajorGridLines_should_set_Visible()
        {
            builder.MajorGridLines(1, "green", ChartDashType.Dot);
            axis.MajorGridLines.Visible.ShouldEqual(true);
        }

        [Fact]
        public void MajorGridLines_should_set_Width()
        {
            builder.MajorGridLines(1, "green", ChartDashType.Dot);
            axis.MajorGridLines.Width.ShouldEqual(1);
        }

        [Fact]
        public void MajorGridLines_should_set_Color()
        {
            builder.MajorGridLines(1, "green", ChartDashType.Dot);
            axis.MajorGridLines.Color.ShouldEqual("green");
        }
        
        [Fact]
        public void MajorGridLines_should_set_DashType()
        {
            builder.MajorGridLines(1, "green", ChartDashType.Dot);
            axis.MajorGridLines.DashType.ShouldEqual(ChartDashType.Dot);
        }

        [Fact]
        public void MinorGridLines_should_return_builder()
        {
            builder.MinorGridLines(lines => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void MinorGridLines_should_set_Visible()
        {
            builder.MinorGridLines(1, "green", ChartDashType.Dot);
            axis.MinorGridLines.Visible.ShouldEqual(true);
        }

        [Fact]
        public void MinorGridLines_should_set_Width()
        {
            builder.MinorGridLines(1, "green", ChartDashType.Dot);
            axis.MinorGridLines.Width.ShouldEqual(1);
        }

        [Fact]
        public void MinorGridLines_should_set_Color()
        {
            builder.MinorGridLines(1, "green", ChartDashType.Dot);
            axis.MinorGridLines.Color.ShouldEqual("green");
        }

        [Fact]
        public void MinorGridLines_should_set_DashType()
        {
            builder.MinorGridLines(1, "green", ChartDashType.Dot);
            axis.MinorGridLines.DashType.ShouldEqual(ChartDashType.Dot);
        }

        [Fact]
        public void Line_should_return_builder()
        {
            builder.Line(line => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Line_should_set_Visible()
        {
            builder.Line(1, "green", ChartDashType.Dot);
            axis.Line.Visible.ShouldEqual(true);
        }

        [Fact]
        public void Line_should_set_Width()
        {
            builder.Line(1, "green", ChartDashType.Dot);
            axis.Line.Width.ShouldEqual(1);
        }

        [Fact]
        public void Line_should_set_Color()
        {
            builder.Line(1, "green", ChartDashType.Dot);
            axis.Line.Color.ShouldEqual("green");
        }

        [Fact]
        public void Line_should_set_DashType()
        {
            builder.Line(1, "green", ChartDashType.Dot);
            axis.Line.DashType.ShouldEqual(ChartDashType.Dot);
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
            builder.Labels(labels => { }).ShouldBeSameAs(builder);
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

        private void AssertCategories(IEnumerable<string> categories)
        {
            var expectedCategories = new Queue<string>();
            foreach (var category in categories)
            {
                expectedCategories.Enqueue(category);
                                
            }

            var categoryStrings = new List<string>();
            foreach (object category in categoryStrings)
            {
                expectedCategories.Dequeue().ShouldEqual(category.ToString());
            }

        }
    }
}