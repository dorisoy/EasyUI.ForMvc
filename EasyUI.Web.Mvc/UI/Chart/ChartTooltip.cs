




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents the chart data point tootlip
    /// </summary>
    public class ChartTooltip
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartLegend" /> class.
        /// </summary>
        public ChartTooltip()
        {
            Font = ChartDefaults.Tooltip.Font;
            Visible = ChartDefaults.Tooltip.Visible;
            Padding = new ChartSpacing(ChartDefaults.Tooltip.Padding);
            Border = new ChartElementBorder(
                ChartDefaults.Tooltip.Border.Width,
                ChartDefaults.Tooltip.Border.Color,
                ChartDefaults.Tooltip.Border.DashType
            );
            Opacity = ChartDefaults.Tooltip.Opacity;
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
        public ChartSpacing Padding
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
        /// Gets or sets the label background.
        /// </summary>
        /// <value>
        /// The label background.
        /// </value>
        public string Background
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the label color.
        /// </summary>
        /// <value>
        /// The label color.
        /// </value>
        public string Color
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the label format.
        /// </summary>
        /// <value>
        /// The label format.
        /// </value>
        public string Format
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the tooltip template.
        /// </summary>
        /// <value>
        /// The tooltip template.
        /// </value>
        public string Template
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the tooltip opacity.
        /// </summary>
        /// <value>
        /// The tooltip opacity.
        /// </value>
        public double Opacity
        {
            get;
            set;
        }

        /// <summary>
        /// Creates a serializer
        /// </summary>
        public IChartSerializer CreateSerializer()
        {
            return new ChartTooltipSerializer(this);
        }
    }
}