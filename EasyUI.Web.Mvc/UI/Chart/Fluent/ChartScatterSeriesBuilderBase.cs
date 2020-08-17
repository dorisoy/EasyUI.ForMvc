




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using System;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.UI;

    /// <summary>
    /// Defines the fluent interface for configuring scatter series.
    /// </summary>
    /// <typeparam name="T">The type of the data item</typeparam>
    public abstract class ChartScatterSeriesBuilderBase<TSeries, TBuilder> : ChartSeriesBuilderBase<TSeries, TBuilder>
        where TSeries : IChartScatterSeries
        where TBuilder : ChartScatterSeriesBuilderBase<TSeries, TBuilder>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartScatterSeriesBuilderBase{T}"/> class.
        /// </summary>
        /// <param name="series">The series.</param>
        public ChartScatterSeriesBuilderBase(TSeries series)
            : base(series)
        {
        }

        /// <summary>
        /// Configures the scatter chart labels.
        /// </summary>
        /// <param name="configurator">The configuration action.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Chart()
        ///             .Name("Chart")
        ///             .Series(series => series
        ///                 .Scatter(s => s.x, s => s.y)
        ///                 .Labels(labels => labels
        ///                     .Position(ChartBarLabelsPosition.Above)
        ///                     .Visible(true)
        ///                 );
        ///              )
        /// %&gt;
        /// </code>
        /// </example>
        public TBuilder Labels(Action<ChartPointLabelsBuilder> configurator)
        {
            Guard.IsNotNull(configurator, "configurator");

            configurator(new ChartPointLabelsBuilder(Series.Labels));

            return this as TBuilder;
        }

        /// <summary>
        /// Sets the visibility of scatter chart labels.
        /// </summary>
        /// <param name="visible">The visibility. The default value is false.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Chart()
        ///             .Name("Chart")
        ///             .Series(series => series
        ///                 .Scatter(s => s.x, s => s.y)
        ///                 .Labels(true);
        ///              )
        /// %&gt;
        /// </code>
        /// </example>
        public TBuilder Labels(bool visible)
        {
            Series.Labels.Visible = visible;

            return this as TBuilder;
        }

        /// <summary>
        /// Configures the scatter chart markers.
        /// </summary>
        /// <param name="configurator">The configuration action.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Chart()
        ///             .Name("Chart")
        ///             .Series(series => series
        ///                 .Scatter(s => s.x, s => s.y)
        ///                 .Markers(markers => markers
        ///                     .Type(ChartMarkerShape.Triangle)
        ///                 );
        ///              )
        /// %&gt;
        /// </code>
        /// </example>
        public TBuilder Markers(Action<ChartMarkersBuilder> configurator)
        {
            Guard.IsNotNull(configurator, "configurator");

            configurator(new ChartMarkersBuilder(Series.Markers));

            return this as TBuilder;
        }

        /// <summary>
        /// Sets the visibility of scatter chart markers.
        /// </summary>
        /// <param name="visible">The visibility. The default value is true.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Chart()
        ///             .Name("Chart")
        ///             .Series(series => series
        ///                 .Scatter(s => s.x, s => s.y)
        ///                 .Markers(true);
        ///              )
        /// %&gt;
        /// </code>
        /// </example>
        public TBuilder Markers(bool visible)
        {
            Series.Markers.Visible = visible;

            return this as TBuilder;
        }
    }
}