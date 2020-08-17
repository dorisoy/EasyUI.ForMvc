




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents a series in the <see cref="EasyUI.Web.Mvc.UI.Chart{T}"/> component
    /// </summary>
    /// <typeparam name="T">The type of the data item</typeparam>
    public abstract class ChartSeriesBase<T> : IChartSeries where T : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartSeriesBase{T}" /> class.
        /// </summary>
        /// <param name="chart">The chart.</param>
        protected ChartSeriesBase(Chart<T> chart)
        {
            Chart = chart;
            Opacity = 1;
        }

        /// <summary>
        /// Gets or sets the chart.
        /// </summary>
        /// <value>The chart.</value>
        public Chart<T> Chart
        {
            get;
            private set;
        }

        /// <summary>
        /// Gets or sets the title of the series.
        /// </summary>
        /// <value>The title.</value>
        public string Name
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the series opacity.
        /// </summary>
        /// <value>A value between 0 (transparent) and 1 (opaque).</value>
        public double Opacity
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the series base color
        /// </summary>
        public string Color
        {
            get;
            set;
        }

        /// <summary>
        /// Creates a serializer for the series
        /// </summary>
        public virtual IChartSerializer CreateSerializer()
        {
            return new ChartSeriesSerializer(this);
        }
    }
}