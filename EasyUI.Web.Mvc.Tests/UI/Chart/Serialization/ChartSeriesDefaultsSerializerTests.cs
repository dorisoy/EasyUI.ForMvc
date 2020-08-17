﻿namespace EasyUI.Web.Mvc.UI.Tests
{
    using System.Collections;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI.Tests.Chart;
    using Xunit;

    public class ChartSeriesDefaultsSerializerTests
    {
        private readonly ChartSeriesDefaults<SalesData> seriesDefaults;

        public ChartSeriesDefaultsSerializerTests()
        {
            var chart = ChartTestHelper.CreateChart<SalesData>();
            seriesDefaults = new ChartSeriesDefaults<SalesData>(chart);
        }

        [Fact]
        public void Serializes_bar_defaults()
        {
            seriesDefaults.Bar.Stacked = true;
            GetJson(seriesDefaults).ContainsKey("bar");
        }

        [Fact]
        public void Serializes_column_defaults()
        {
            seriesDefaults.Column.Stacked = true;
            GetJson(seriesDefaults).ContainsKey("column");
        }

        [Fact]
        public void Serializes_pie_defaults()
        {
            seriesDefaults.Pie.StartAngle = 45;
            GetJson(seriesDefaults).ContainsKey("pie");
        }

        [Fact]
        public void Serializes_scatter_defaults()
        {
            seriesDefaults.Scatter.Opacity = 0.5;
            GetJson(seriesDefaults).ContainsKey("scatter");
        }

        [Fact]
        public void Serializes_scatterLine_defaults()
        {
            seriesDefaults.ScatterLine.Opacity = 0.5;
            GetJson(seriesDefaults).ContainsKey("scatterLine");
        }

        [Fact]
        public void Strips_type_from_bar_defaults()
        {
            seriesDefaults.Bar.Stacked = true;
            var barData = GetJson(seriesDefaults)["bar"];
            ((IDictionary<string, object>) barData).ContainsKey("type").ShouldBeFalse();
        }

        [Fact]
        public void Strips_type_from_column_defaults()
        {
            seriesDefaults.Column.Stacked = true;
            var barData = GetJson(seriesDefaults)["column"];
            ((IDictionary<string, object>)barData).ContainsKey("type").ShouldBeFalse();
        }

        [Fact]
        public void Strips_type_from_pie_defaults()
        {
            seriesDefaults.Pie.StartAngle = 45;
            var pieData = GetJson(seriesDefaults)["pie"];
            ((IDictionary<string, object>)pieData).ContainsKey("type").ShouldBeFalse();
        }

        [Fact]
        public void Strips_type_from_scatter_defaults()
        {
            seriesDefaults.Scatter.Opacity = 0.5;
            var scatterData = GetJson(seriesDefaults)["scatter"];
            ((IDictionary<string, object>)scatterData).ContainsKey("type").ShouldBeFalse();
        }

        [Fact]
        public void Strips_type_from_scatterLine_defaults()
        {
            seriesDefaults.ScatterLine.Opacity = 0.5;
            var scatterLineData = GetJson(seriesDefaults)["scatterLine"];
            ((IDictionary<string, object>)scatterLineData).ContainsKey("type").ShouldBeFalse();
        }

        private static IDictionary<string, object> GetJson(IChartSeriesDefaults seriesDefaults)
        {
            return seriesDefaults.CreateSerializer().Serialize();
        }
    }
}