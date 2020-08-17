




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents the options of the chart labels
    /// </summary>
    public abstract class ChartLabels : IChartLabels
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartLabels" /> class.
        /// </summary>
        protected ChartLabels()
        {
            Font = ChartDefaults.Labels.Font;
            Visible = ChartDefaults.Labels.Visible;
            Margin = new ChartSpacing(ChartDefaults.Labels.Margin);
            Padding = new ChartSpacing(ChartDefaults.Labels.Padding);
            Border = new ChartElementBorder(
                ChartDefaults.Labels.Border.Width,
                ChartDefaults.Labels.Border.Color,
                ChartDefaults.Labels.Border.DashType
            );
            Color = ChartDefaults.Labels.Color;
            Opacity = ChartDefaults.Labels.Opacity;
            Rotation = ChartDefaults.Labels.Rotation;
        }

        /// <summary>
        /// Gets or sets the label font.
        /// </summary>
        /// <value>
        /// Specify a font in CSS format. For example "12px Arial,Helvetica,sans-serif".
        /// </value>
        public string Font
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets a value indicating if the label is visible
        /// </summary>
        public bool Visible
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
        /// Gets or sets the label border.
        /// </summary>
        /// <value>
        /// The label border.
        /// </value>
        public ChartElementBorder Border
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the label margin.
        /// </summary>
        /// <value>
        /// The label margin.
        /// </value>
        public ChartSpacing Margin
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the label padding.
        /// </summary>
        /// <value>
        /// The label padding.
        /// </value>
        public ChartSpacing Padding
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
        /// Gets or sets the label template.
        /// </summary>
        /// <value>
        /// The label template.
        /// </value>
        public string Template
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the label opacity.
        /// </summary>
        /// <value>
        /// The label opacity.
        /// </value>
        public double Opacity
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the label opacity.
        /// </summary>
        /// <value>
        /// The label opacity.
        /// </value>
        public double Rotation
        {
            get;
            set;
        }

        /// <summary>
        /// Creates a serializer
        /// </summary>
        public abstract IChartSerializer CreateSerializer();
    }
}