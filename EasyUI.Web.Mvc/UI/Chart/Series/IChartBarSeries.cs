﻿




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents chart bar or column series
    /// </summary>
    public interface IChartBarSeries : IChartBoundSeries
    {
        /// <summary>
        /// A value indicating if the bars should be stacked.
        /// </summary>
        bool Stacked
        {
            get;
            set;
        }

        /// <summary>
        /// The distance between category clusters.
        /// </summary>
        double Gap
        {
            get;
            set;
        }

        /// <summary>
        /// Space between bars.
        /// </summary>
        double Spacing
        {
            get;
            set;
        }

        /// <summary>
        /// The orientation of the bars.
        /// </summary>
        ChartBarSeriesOrientation Orientation
        {
            get;
            set;
        }

        /// <summary>
        /// Gets the bar chart data labels configuration
        /// </summary>
        ChartBarLabels Labels
        {
            get;
        }

        /// <summary>
        /// Gets or sets the bar's border
        /// </summary>
        ChartElementBorder Border
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the effects overlay
        /// </summary>
        ChartBarSeriesOverlay Overlay
        {
            get;
            set;
        }
    }
}