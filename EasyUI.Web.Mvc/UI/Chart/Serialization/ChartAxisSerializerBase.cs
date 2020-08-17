




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    internal class ChartAxisSerializerBase : IChartSerializer
    {
        private readonly IChartAxis axis;

        public ChartAxisSerializerBase(IChartAxis axis)
        {
            this.axis = axis;
        }

        public virtual IDictionary<string, object> Serialize()
        {
            var result = new Dictionary<string, object>();
            
            FluentDictionary.For(result)
                .Add("minorTickSize", axis.MinorTickSize, ChartDefaults.Axis.MinorTickSize)
                .Add("majorTickSize", axis.MajorTickSize, ChartDefaults.Axis.MajorTickSize)
                .Add("majorTickType", axis.MajorTickType.ToString(), ChartDefaults.Axis.MajorTickType.ToString())
                .Add("minorTickType", axis.MinorTickType.ToString(), ChartDefaults.Axis.MinorTickType.ToString())
                .Add("axisCrossingValue", axis.AxisCrossingValue, () => axis.AxisCrossingValue.HasValue)
                .Add("orientation", axis.Orientation.ToString().ToLowerInvariant(), () => axis.Orientation.HasValue);

            var labelsData = axis.Labels.CreateSerializer().Serialize();
            if (labelsData.Count > 0)
            {
                result.Add("labels", labelsData);
            }

            var majorGridLines = axis.MajorGridLines.CreateSerializer().Serialize();
            if (majorGridLines.Count > 0)
            {
                result.Add("majorGridLines", majorGridLines);
            }

            var minorGridLines = axis.MinorGridLines.CreateSerializer().Serialize();
            if (minorGridLines.Count > 0)
            {
                result.Add("minorGridLines", minorGridLines);
            }

            var line = axis.Line.CreateSerializer().Serialize();
            if (line.Count > 0)
            {
                result.Add("line", line);
            }

            return result;
        }
    }
}