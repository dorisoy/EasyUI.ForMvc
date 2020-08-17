




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents the options of the axis labels
    /// </summary>
    public class ChartAxisLabels : ChartLabels
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartAxisLabels" /> class.
        /// </summary>
        public ChartAxisLabels()
        {
        }

        /// <summary>
        /// Creates a serializer
        /// </summary>
        public override IChartSerializer CreateSerializer()
        {
            return new ChartAxisLabelsSerializer(this);
        }
    }
}