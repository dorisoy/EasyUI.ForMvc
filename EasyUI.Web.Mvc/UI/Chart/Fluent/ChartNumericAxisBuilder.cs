﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{
    /// <summary>
    /// Defines the fluent interface for configuring numeric axis.
    /// </summary>
    public class ChartNumericAxisBuilder : ChartAxisBuilderBase<IChartNumericAxis, ChartNumericAxisBuilder>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartNumericAxisBuilder"/> class.
        /// </summary>
        /// <param name="axis">The axis.</param>
        public ChartNumericAxisBuilder(IChartNumericAxis axis)
            : base(axis)
        {
        }

        /// <summary>
        /// Sets the axis minimum value.
        /// </summary>
        /// <param name="min">The axis minimum value.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Chart(Model)
        ///             .Name("Chart")
        ///             .ValueAxis(a => a.Numeric().Min(4))
        /// %&gt;
        /// </code>
        /// </example>
        public ChartNumericAxisBuilder Min(double min)
        {
            Axis.Min = min;

            return this;
        }

        /// <summary>
        /// Sets the axis maximum value.
        /// </summary>
        /// <param name="max">The axis maximum value.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Chart(Model)
        ///             .Name("Chart")
        ///             .ValueAxis(a => a.Numeric().Max(4))
        /// %&gt;
        /// </code>
        /// </example>
        public ChartNumericAxisBuilder Max(double max)
        {
            Axis.Max = max;

            return this;
        }

        /// <summary>
        /// Sets the interval between major divisions.
        /// </summary>
        /// <param name="majorUnit">The interval between major divisions.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Chart(Model)
        ///             .Name("Chart")
        ///             .ValueAxis(a => a.Numeric().MajorUnit(4))
        /// %&gt;
        /// </code>
        /// </example>
        public ChartNumericAxisBuilder MajorUnit(double majorUnit)
        {
            Axis.MajorUnit = majorUnit;

            return this;
        }

        /// <summary>
        /// Sets the axis orientation. The CategoryAxis orientation should be set to match.
        /// </summary>
        /// <param name="orientation">The orientation. The default value is inferred from the series type.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Chart(Model)
        ///             .Name("Chart")
        ///             .CategoryAxis(c => c.Orientation(ChartAxisOrientation.Vertical))
        ///             .ValueAxis(v => v.Orientation(ChartAxisOrientation.Horizontal))
        ///             .Series(series => series.Line(s => s.Sales))
        /// %&gt;
        /// </code>
        /// </example>
        public ChartNumericAxisBuilder Orientation(ChartAxisOrientation orientation)
        {
            Axis.Orientation = orientation;

            return this;
        }

        [System.Obsolete("Use Labels(labels => labels.Format(...)) instead of Numeric(axis => axis.Format(...)).", true)]
        public ChartNumericAxisBuilder Format(string format)
        {
            Axis.Format = format;

            return this;
        }
    }
}