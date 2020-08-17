namespace EasyUI.Web.Mvc.UI.Tests
{
    using Moq;
    using Xunit;
    using System.Collections.Generic;

    public class ChartNumericAxisSerializerTests
    {
        private readonly Mock<IChartNumericAxis> axisMock;
        private readonly ChartNumericAxisSerializer serializer;

        public ChartNumericAxisSerializerTests()
        {
            axisMock = new Mock<IChartNumericAxis>();
            serializer = new ChartNumericAxisSerializer(axisMock.Object);

            axisMock.SetupGet(a => a.MajorGridLines).Returns(new ChartLine());
            axisMock.SetupGet(a => a.MinorGridLines).Returns(new ChartLine());
            axisMock.SetupGet(a => a.Line).Returns(new ChartLine());
            axisMock.SetupGet(a => a.Labels).Returns(new ChartAxisLabels());
        }

        [Fact]
        public void Should_serialize_Min()
        {
            axisMock.SetupGet(a => a.Min).Returns(10);
            serializer.Serialize()["min"].ShouldEqual(10.0);
        }

        [Fact]
        public void Should_not_serialize_Min_if_not_set()
        {
            axisMock.SetupGet(a => a.Min).Returns((double?)null);
            serializer.Serialize().ContainsKey("min").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_Max()
        {
            axisMock.SetupGet(a => a.Max).Returns(10);
            serializer.Serialize()["max"].ShouldEqual(10.0);
        }

        [Fact]
        public void Should_not_serialize_Max_if_not_set()
        {
            axisMock.SetupGet(a => a.Max).Returns((double?)null);
            serializer.Serialize().ContainsKey("max").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_MajorUnit()
        {
            axisMock.SetupGet(a => a.MajorUnit).Returns(10);
            serializer.Serialize()["majorUnit"].ShouldEqual(10.0);
        }

        [Fact]
        public void Should_not_serialize_MajorUnit_if_not_set()
        {
            axisMock.SetupGet(a => a.MajorUnit).Returns((double?)null);
            serializer.Serialize().ContainsKey("majorUnit").ShouldBeFalse();
        }

        [Fact]
        public void Should_serialize_AxisCrossingValue()
        {
            axisMock.SetupGet(a => a.AxisCrossingValue).Returns(10);
            serializer.Serialize()["axisCrossingValue"].ShouldEqual(10.0);
        }

        [Fact]
        public void Should_not_serialize_AxisCrossingValue_if_not_set()
        {
            axisMock.SetupGet(a => a.AxisCrossingValue).Returns((double?)null);
            serializer.Serialize().ContainsKey("axisCrossingValue").ShouldBeFalse();
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
    }
}