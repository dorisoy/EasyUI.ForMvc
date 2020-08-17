﻿namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using System;
    using System.Linq;
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Fluent;
    using Xunit;

    public class ChartBuilderTests
    {
        private readonly Chart<SalesData> chart;
        private readonly ChartBuilder<SalesData> builder;

        public ChartBuilderTests()
        {
            chart = ChartTestHelper.CreateChart<SalesData>();
            builder = new ChartBuilder<SalesData>(chart);
        }

        [Fact]
        public void ClientEvents_should_set_events()
        {
            Action<ChartClientEventsBuilder> clientEventsAction = eventBuilder => eventBuilder.OnLoad("load");
            builder.ClientEvents(clientEventsAction);
            chart.ClientEvents.OnLoad.HandlerName.ShouldEqual("load");
        }

        [Fact]
        public void ClientEvents_should_return_builder()
        {
            builder.ClientEvents(eventBuilder => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Theme_should_set_Theme()
        {
            builder.Theme("EasyUI");
            chart.Theme.ShouldEqual("EasyUI");
        }

        [Fact]
        public void Theme_should_return_builder()
        {
            builder.Theme("").ShouldBeSameAs(builder);
        }

        [Fact]
        public void Title_should_set_Title()
        {
            builder.Title("Chart Title");
            chart.Title.Text.ShouldEqual("Chart Title");
        }

        [Fact]
        public void Title_should_return_builder()
        {
            builder.Title("").ShouldBeSameAs(builder);
        }

        [Fact]
        public void Title_should_set_visibility()
        {
            builder.Legend(true).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Legend_should_set_visibility()
        {
            builder.Legend(false);
            chart.Legend.Visible.ShouldBeFalse();
        }

        [Fact]
        public void Legend_should_return_builder()
        {
            builder.Legend(true).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Legend_with_builder_should_return_builder()
        {
            builder.Legend(legend => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void ChartArea_with_builder_should_return_builder()
        {
            builder.ChartArea(chartArea => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Series_should_return_builder()
        {
            builder.Series(series => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void SeriesDefaults_should_return_builder()
        {
            builder.SeriesDefaults(seriesDefaults => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void CategoryAxis_return_builder()
        {
            builder.CategoryAxis(axis => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void DataBinding_return_builder()
        {
            builder.DataBinding(dataBinding => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void SeriesColors_should_return_builder()
        {
            builder.SeriesColors(new string[] { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void SeriesColors_should_set_seriesColors()
        {
            var colors = new string[] { "red" };
            builder.SeriesColors(colors);

            builder.Component.SeriesColors.ShouldBeSameAs(colors);
        }

        [Fact]
        public void SeriesColors_should_set_seriesColors_from_params()
        {
            builder.SeriesColors("red");

            builder.Component.SeriesColors.First().ShouldEqual("red");
        }

        [Fact]
        public void Tooltip_should_set_visibility()
        {
            builder.Tooltip(true);
            chart.Tooltip.Visible.ShouldBeTrue();
        }

        [Fact]
        public void Tooltip_should_return_builder()
        {
            builder.Tooltip(true).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Tooltip_with_builder_should_configure_tooltip()
        {
            builder.Tooltip(tooltip => { tooltip.Visible(true); });
            chart.Tooltip.Visible.ShouldBeTrue();
        }

        [Fact]
        public void Tooltip_with_builder_should_return_builder()
        {
            builder.Tooltip(legend => { }).ShouldBeSameAs(builder);
        }

        [Fact]
        public void XAxis_should_set_XAxis_properties()
        {
            builder.XAxis(x => x.Max(4));
            chart.XAxis.Max.ShouldEqual(4);
        }

        [Fact]
        public void XAxis_should_return_builder()
        {
            builder.XAxis(x => x.Max(4)).ShouldBeSameAs(builder);
        }

        [Fact]
        public void YAxis_should_set_YAxis_properties()
        {
            builder.YAxis(y => y.Max(4));
            chart.YAxis.Max.ShouldEqual(4);
        }

        [Fact]
        public void YAxis_should_return_builder()
        {
            builder.YAxis(y => y.Max(4)).ShouldBeSameAs(builder);
        }

        [Fact]
        public void Transitions_should_set_Transitions()
        {
            builder.Transitions(false);
            chart.Transitions.ShouldEqual(false);
        }

        [Fact]
        public void Transitions_should_return_builder()
        {
            builder.Transitions(false).ShouldBeSameAs(builder);
        }
    }
}