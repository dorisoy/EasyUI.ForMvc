




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Defines a generic Chart axis
    /// </summary>
    public interface IChartAxis
    {
        /// <summary>
        /// Gets or sets the minor tick size.
        /// </summary>
        int MinorTickSize { get; set; }

        /// <summary>
        /// Gets or sets the major tick size.
        /// </summary>
        int MajorTickSize { get; set; }

        /// <summary>
        /// The major tick type.
        /// </summary>
        ChartAxisTickType MajorTickType { get; set; }

        /// <summary>
        /// The minor tick type.
        /// </summary>
        ChartAxisTickType MinorTickType { get; set; }

        /// <summary>
        /// The major grid lines configuration.
        /// </summary>
        ChartLine MajorGridLines { get; set; }

        /// <summary>
        /// The minor grid lines configuration.
        /// </summary>
        ChartLine MinorGridLines { get; set; }

        /// <summary>
        /// The axis line configuration.
        /// </summary>
        ChartLine Line { get; set; }

        /// <summary>
        /// The value at which the first perpendicular axis crosses this axis
        /// </summary>
        double? AxisCrossingValue { get; set; }

        /// <summary>
        /// The axis labels
        /// </summary>
        ChartAxisLabels Labels { get; set; }

        /// <summary>
        /// Gets the axis serializer.
        /// </summary>
        IChartSerializer CreateSerializer();

        /// <summary>
        /// The axis orientation
        /// </summary>
        ChartAxisOrientation? Orientation { get; set; }
    }
}
