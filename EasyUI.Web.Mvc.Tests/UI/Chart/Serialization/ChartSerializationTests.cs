﻿namespace EasyUI.Web.Mvc.UI.Tests.Chart
{
    using Moq;
    using System.IO;
    using System.Web.Routing;
    using EasyUI.Web.Mvc;
    using EasyUI.Web.Mvc.UI;
    using Xunit;

    public class ChartSerializationTests
    {
        private readonly Chart<SalesData> chart;
        private readonly Mock<TextWriter> textWriter;
        private string output;

        public ChartSerializationTests()
        {
            textWriter = new Mock<TextWriter>();
            textWriter.Setup(tw => tw.Write(It.IsAny<string>())).Callback<string>(s => output += s);

            var urlGeneratorMock = new Mock<IUrlGenerator>();
            urlGeneratorMock.Setup(g => g.Generate(It.IsAny<RequestContext>(), It.IsAny<INavigatable>()))
                .Returns<RequestContext, INavigatable>(
                    (context, navigatable) => 
                        navigatable.Url ?? navigatable.ControllerName + "/" + navigatable.ActionName
                );

            chart = ChartTestHelper.CreateChart<SalesData>(urlGeneratorMock.Object);
            chart.Name = "Chart";
        }

        [Fact]
        public void Default_configuration_outputs_empty_tChart_init()
        {
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart();");
        }

        [Fact]
        public void Title_serialized()
        {
            chart.Title.Text = "Title";
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({title:{\"text\":\"Title\"}});");
        }

        [Fact]
        public void Legend_serialized()
        {
            chart.Legend.Visible = false;
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({legend:{\"visible\":false}});");
        }

        [Fact]
        public void OnLoad_client_side_event_serialized()
        {
            chart.ClientEvents.OnLoad.HandlerName = "loadHandler";
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({onLoad:loadHandler});");
        }

        [Fact]
        public void OnDataBound_client_side_event_serialized()
        {
            chart.ClientEvents.OnDataBound.HandlerName = "dataBoundHandler";
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({onDataBound:dataBoundHandler});");
        }

        [Fact]
        public void OnSeriesClick_client_side_event_serialized()
        {
            chart.ClientEvents.OnSeriesClick.HandlerName = "seriesClickHandler";
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({onSeriesClick:seriesClickHandler});");
        }

        [Fact]
        public void Series_should_be_serialized_when_defined()
        {
            chart.Series.Add(new ChartBarSeries<SalesData, decimal>(chart, s => s.RepSales));
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({series:[{\"name\":\"Rep Sales\",\"type\":\"bar\",\"field\":\"RepSales\"}]});");
        }

        [Fact]
        public void SeriesDefaults_should_be_serialized_when_set() 
        {
            chart.SeriesDefaults.Bar.Gap = 4;
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({seriesDefaults:{\"bar\":{\"gap\":4}}});");
        }

        [Fact]
        public void CategoryAxis_should_be_serialized_when_categories_are_defined()
        {
            chart.CategoryAxis.Categories = new string[] { "A" };
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({categoryAxis:{\"categories\":[\"A\"]}});");
        }

        [Fact]
        public void CategoryAxis_should_be_serialized_when_bound()
        {
            chart.CategoryAxis.Member = "RepName";
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({categoryAxis:{\"field\":\"RepName\"}});");
        }

        [Fact]
        public void ValueAxis_should_be_serialized()
        {
            var numericAxis = new ChartNumericAxis<SalesData>(chart);
            numericAxis.Min = 1;
            chart.ValueAxis = numericAxis;
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({valueAxis:{\"min\":1}});");
        }

        [Fact]
        public void XAxis_should_be_serialized()
        {
            chart.XAxis.Max = 4;
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({xAxis:{\"max\":4}});");
        }

        [Fact]
        public void YAxis_should_be_serialized()
        {
            chart.YAxis.Max = 4;
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({yAxis:{\"max\":4}});");
        }

        [Fact]
        public void DataBinding_should_be_serialized_when_using_Ajax_binding()
        {
            chart.DataBinding.Ajax.Enabled = true;
            chart.DataBinding.Ajax.Select.ActionName = "Action";
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({dataSource:{\"transport\":{\"read\":{\"url\":\"/Action\",\"type\":\"POST\"}}}});");
        }

        [Fact]
        public void SeriesColors_should_be_serialized()
        {
            chart.SeriesColors = new string[] { "red", "green", "blue" };
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({seriesColors:[\"red\",\"green\",\"blue\"]});");
        }

        [Fact]
        public void Tooltip_should_be_serialized()
        {
            chart.Tooltip.Visible = true;
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({tooltip:{\"visible\":true}});");
        }

        [Fact]
        public void Transitions_serialized()
        {
            chart.Transitions = false;
            chart.WriteInitializationScript(textWriter.Object);

            output.ShouldEqual("jQuery('#Chart').tChart({transitions:false});");
        }
    }
}