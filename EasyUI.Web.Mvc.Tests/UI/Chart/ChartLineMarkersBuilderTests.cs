﻿namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Fluent;
    using Xunit;

    public class ChartLineMarkersBuilderTests
    {
        private readonly ChartMarkers markers;
        private readonly ChartMarkersBuilder builder;

        public ChartLineMarkersBuilderTests()
        {
            markers = new ChartMarkers();
            builder = new ChartMarkersBuilder(markers);
        }

        [Fact]
        public void Visible_sets_Visible()
        {
            builder.Visible(false);
            markers.Visible.ShouldBeFalse();
        }

        [Fact]
        public void Type_sets_type()
        {
            builder.Type(ChartMarkerShape.Square);
            markers.Type.ShouldEqual(ChartMarkerShape.Square);
        }

        [Fact]
        public void Size_sets_size()
        {
            builder.Size(10);
            markers.Size.ShouldEqual(10);
        }

        [Fact]
        public void Background_sets_background()
        {
            builder.Background("Blue");
            markers.Background.ShouldEqual("Blue");
        }

        [Fact]
        public void Border_sets_width_and_color()
        {
            builder.Border(1, "red", ChartDashType.Dot);
            markers.Border.Color.ShouldEqual("red");
            markers.Border.Width.ShouldEqual(1);
            markers.Border.DashType.ShouldEqual(ChartDashType.Dot);
        }
    }
}