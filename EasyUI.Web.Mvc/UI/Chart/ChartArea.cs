




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents the Chart area options
    /// </summary>
    public class ChartArea
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartArea" /> class.
        /// </summary>
        public ChartArea()
        {
            Background = ChartDefaults.ChartArea.background;
            Margin = new ChartSpacing(ChartDefaults.ChartArea.Margin);
            Border = new ChartElementBorder(
                    ChartDefaults.ChartArea.Border.Width,
                    ChartDefaults.ChartArea.Border.Color,
                    ChartDefaults.ChartArea.Border.DashType
                );
        }

        /// <summary>
        /// Gets or sets the Chart area background.
        /// </summary>
        /// <value>
        /// The Chart area background.
        /// </value>
        public string Background
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the Chart area border.
        /// </summary>
        /// <value>
        /// The Chart area border.
        /// </value>
        public ChartElementBorder Border
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the Chart area margin.
        /// </summary>
        /// <value>
        /// The Chart area margin.
        /// </value>
        public ChartSpacing Margin
        {
            get;
            set;
        }

        /// <summary>
        /// Creates a serializer
        /// </summary>
        public IChartSerializer CreateSerializer()
        {
            return new ChartAreaSerializer(this);
        }
    }
}