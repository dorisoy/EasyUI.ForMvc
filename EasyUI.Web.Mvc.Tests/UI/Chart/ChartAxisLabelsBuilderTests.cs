﻿namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Fluent;
    using Xunit;

    public class ChartAxisLabelsBuilderTests
    {
        private readonly ChartAxisLabels labels;
        private readonly ChartAxisLabelsBuilder builder;

        public ChartAxisLabelsBuilderTests()
        {
            labels = new ChartAxisLabels();
            builder = new ChartAxisLabelsBuilder(labels);
        }

        [Fact]
        public void Font_sets_Font()
        {
            builder.Font("Font");
            labels.Font.ShouldEqual("Font");
        }

        [Fact]
        public void Visible_sets_Visible()
        {
            builder.Visible(false);
            labels.Visible.ShouldBeFalse();
        }

        [Fact]
        public void Rotation_sets_Rotation()
        {
            builder.Rotation(20);
            labels.Rotation.ShouldEqual(20);
        }

        [Fact]
        public void Color_sets_color()
        {
            builder.Color("Red");
            labels.Color.ShouldEqual("Red");
        }

        [Fact]
        public void Background_sets_background()
        {
            builder.Background("Blue");
            labels.Background.ShouldEqual("Blue");
        }

        [Fact]
        public void Margin_sets_margins()
        {
            builder.Margin(20);
            labels.Margin.Top.ShouldEqual(20);
            labels.Margin.Right.ShouldEqual(20);
            labels.Margin.Bottom.ShouldEqual(20);
            labels.Margin.Left.ShouldEqual(20);

            builder.Margin(1, 2, 3, 4);
            labels.Margin.Top.ShouldEqual(1);
            labels.Margin.Right.ShouldEqual(2);
            labels.Margin.Bottom.ShouldEqual(3);
            labels.Margin.Left.ShouldEqual(4);
        }

        [Fact]
        public void Padding_sets_paddings()
        {
            builder.Padding(20);
            labels.Padding.Top.ShouldEqual(20);
            labels.Padding.Right.ShouldEqual(20);
            labels.Padding.Bottom.ShouldEqual(20);
            labels.Padding.Left.ShouldEqual(20);

            builder.Padding(1, 2, 3, 4);
            labels.Padding.Top.ShouldEqual(1);
            labels.Padding.Right.ShouldEqual(2);
            labels.Padding.Bottom.ShouldEqual(3);
            labels.Padding.Left.ShouldEqual(4);
        }

        [Fact]
        public void Border_sets_width_and_color()
        {
            builder.Border(1, "red", ChartDashType.Dot);
            labels.Border.Color.ShouldEqual("red");
            labels.Border.Width.ShouldEqual(1);
            labels.Border.DashType.ShouldEqual(ChartDashType.Dot);
        }

        [Fact]
        public void Format_sets_format()
        {
            builder.Format("{0:C}");
            labels.Format.ShouldEqual("{0:C}");
        }

        [Fact]
        public void Template_sets_template()
        {
            builder.Template("<# CustomerID #>");
            labels.Template.ShouldEqual("<# CustomerID #>");
        }

        [Fact]
        public void Opacity_sets_Opacity()
        {
            builder.Opacity(0.5);
            labels.Opacity.ShouldEqual(0.5);
        }
    }
}