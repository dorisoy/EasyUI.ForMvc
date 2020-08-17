




namespace EasyUI.Web.Mvc.UI.Fluent
{
    /// <summary>
    /// Defines the fluent interface for configuring the chart labels.
    /// </summary>
    public class ChartAxisLabelsBuilder : ChartLabelsBuilderBase<ChartAxisLabelsBuilder>
    {
        private readonly ChartAxisLabels ChartLabels;
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartAxisLabelsBuilder" /> class.
        /// </summary>
        /// <param name="chartLabels">The labels configuration.</param>
        public ChartAxisLabelsBuilder(ChartAxisLabels chartLabels)
            : base(chartLabels)
        {
            this.ChartLabels = chartLabels;
        }
    }
}