﻿




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents the chart legend
    /// </summary>
    public class ChartLegend
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartLegend" /> class.
        /// </summary>
        public ChartLegend()
        {
            Font = ChartDefaults.Legend.Font;
            Color = ChartDefaults.Legend.Color;
            Position = ChartDefaults.Legend.Position;
            Visible = ChartDefaults.Legend.Visible;
            Margin = new ChartSpacing(ChartDefaults.Legend.Margin);
            Padding = new ChartSpacing(ChartDefaults.Legend.Padding);
            Border = new ChartElementBorder(
                    ChartDefaults.Legend.Border.Width,
                    ChartDefaults.Legend.Border.Color,
                    ChartDefaults.Legend.Border.DashType
                );
        }

        /// <summary>
        /// Gets or sets the legend font.
        /// </summary>
        /// <value>
        /// Specify a font in CSS format. For example "16px Arial,Helvetica,sans-serif".
        /// </value>
        public string Font
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the legend labels color.
        /// </summary>
        /// <value>
        /// Specify the color of the labels.
        /// </value>
        public string Color
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the legend position.
        /// </summary>
        /// <remarks>
        /// The default value is <see cref="ChartLegendPosition.Right"/>
        /// </remarks>
        public ChartLegendPosition Position
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the legend X-offset from its position.
        /// </summary>
        public int OffsetX
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the legend Y-offset from its position.
        /// </summary>
        public int OffsetY
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets a value indicating if the legend is visible
        /// </summary>
        public bool Visible
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the legend margin
        /// </summary>
        public ChartSpacing Margin
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the legend margin
        /// </summary>
        public ChartSpacing Padding
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the legend background color
        /// </summary>
        public string Background
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the legend border
        /// </summary>
        public ChartElementBorder Border
        {
            get;
            set;
        }

        /// <summary>
        /// Creates a serializer
        /// </summary>
        public IChartSerializer CreateSerializer()
        {
            return new ChartLegendSerializer(this);
        }
    }
}