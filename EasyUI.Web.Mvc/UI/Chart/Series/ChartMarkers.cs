




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents chart line markers styling
    /// </summary>
    public class ChartMarkers
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartMarkers" /> class.
        /// </summary>
        public ChartMarkers()
        {
            Size = ChartDefaults.LineSeries.Markers.Size;
            Background = ChartDefaults.LineSeries.Markers.Background;
            Visible = ChartDefaults.LineSeries.Markers.Visible;
            Type = ChartDefaults.LineSeries.Markers.Type;
            Border = new ChartElementBorder(
                    ChartDefaults.LineSeries.Markers.Border.Width,
                    ChartDefaults.LineSeries.Markers.Border.Color,
                    ChartDefaults.LineSeries.Markers.Border.DashType
                );
        }

        /// <summary>
        /// Gets or sets the markers size.
        /// </summary>
        public int Size
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the markers background.
        /// </summary>
        public string Background
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the markers type.
        /// </summary>
        public ChartMarkerShape Type
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the markers visibility.
        /// </summary>
        public bool Visible
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the markers border.
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
            return new ChartLineMarkersSerializer(this);
        }
    }
}