namespace EasyUI.Web.Mvc.UI.Tests
{
    using Moq;
    using System.Collections;
    using Xunit;

    public class ChartCategoryAxisSerializerTests
    {
        private readonly Mock<IChartCategoryAxis> axisMock;
        private readonly ChartCategoryAxisSerializer serializer;

        public ChartCategoryAxisSerializerTests()
        {
            axisMock = new Mock<IChartCategoryAxis>();
            serializer = new ChartCategoryAxisSerializer(axisMock.Object);

            axisMock.SetupGet(a => a.MajorGridLines).Returns(new ChartLine());
            axisMock.SetupGet(a => a.MinorGridLines).Returns(new ChartLine());
            axisMock.SetupGet(a => a.Line).Returns(new ChartLine());
            axisMock.SetupGet(a => a.Labels).Returns(new ChartAxisLabels());
        }

        [Fact]
        public void Should_serialize_categories()
        {
            axisMock.SetupGet(a => a.Categories).Returns(new string[] { "A", "B" });
            (serializer.Serialize()["categories"] is IEnumerable).ShouldBeTrue();
        }

        [Fact]
        public void Should_serialize_field()
        {
            axisMock.SetupGet(a => a.Member).Returns("RepName");
            axisMock.SetupGet(a => a.Categories).Returns((IEnumerable)null);
            serializer.Serialize()["field"].ShouldEqual("RepName");
        }

        [Fact]
        public void Should_not_serialize_field_if_not_set()
        {
            axisMock.SetupGet(a => a.Member).Returns((string)null);
            axisMock.SetupGet(a => a.Categories).Returns((IEnumerable)null);
            serializer.Serialize().ContainsKey("field").ShouldBeFalse();
        }

        [Fact]
        public void Should_not_serialize_field_if_has_categories()
        {
            axisMock.SetupGet(a => a.Member).Returns("RepName");
            axisMock.SetupGet(a => a.Categories).Returns(new string[] { "A", "B" });
            serializer.Serialize().ContainsKey("field").ShouldBeFalse();
        }

        [Fact]
        public void Should_not_serialize_majorGridLines_if_not_set()
        {
            serializer.Serialize().ContainsKey("majorGridLines").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_majorGridLines_if_set()
        {
            axisMock.SetupGet(a => a.MajorGridLines).Returns(
                new ChartLine(1, "white", ChartDashType.Dot, true)
            );

            serializer.Serialize().ContainsKey("majorGridLines").ShouldBeTrue();
        }

        [Fact]
        public void Should_not_serialize_minorGridLines_if_not_set()
        {
            serializer.Serialize().ContainsKey("minorGridLines").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_minorGridLines_if_set()
        {
            axisMock.SetupGet(a => a.MinorGridLines).Returns(
                new ChartLine(1, "white", ChartDashType.Dot, true)
            );

            serializer.Serialize().ContainsKey("minorGridLines").ShouldBeTrue();
        }

        [Fact]
        public void Should_not_serialize_labels_if_not_set()
        {
            serializer.Serialize().ContainsKey("labels").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_labels_if_set()
        {
            axisMock.SetupGet(a => a.Labels).Returns(new ChartAxisLabels() { Color = "Red" });

            serializer.Serialize().ContainsKey("labels").ShouldBeTrue();
        }

        [Fact]
        public void Should_serialize_visible_if_set()
        {
            axisMock.SetupGet(a => a.Labels).Returns(new ChartAxisLabels() { Visible = false });

            serializer.Serialize().ContainsKey("visible").ShouldBeFalse();
        }
    }
}