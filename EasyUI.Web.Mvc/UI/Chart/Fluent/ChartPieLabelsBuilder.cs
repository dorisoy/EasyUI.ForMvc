﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{
    /// <summary>
    /// Defines the fluent interface for configuring the chart data labels.
    /// </summary>
    public class ChartPieLabelsBuilder : ChartLabelsBuilderBase<ChartPieLabelsBuilder>
    {
        private readonly ChartPieLabels pieLabels;

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartPieLabelsBuilder" /> class.
        /// </summary>
        /// <param name="chartBarLabels">The data labels configuration.</param>
        public ChartPieLabelsBuilder(ChartPieLabels chartPieLabels)
            : base(chartPieLabels)
        {
            pieLabels = chartPieLabels;
        }

        /// <summary>
        /// Sets the labels align
        /// </summary>
        /// <param name="align">The labels align.</param>
        /// <example>
        /// <code lang="CS">
        /// &lt;% Html.EasyUI().Chart()
        ///           .Name("Chart")
        ///           .Series(series => series
        ///               .Pie(p => p.Sales)
        ///               .Labels(labels => labels
        ///                   .Align(ChartPieLabelsAlign.Column)
        ///                   .Visible(true)
        ///               );
        ///            )
        ///           .Render();
        /// %&gt;
        /// </code>
        /// </example>        
        public ChartPieLabelsBuilder Align(ChartPieLabelsAlign align)
        {
            pieLabels.Align = align;
            return this;
        }

        /// <summary>
        /// Sets the labels distance
        /// </summary>
        /// <param name="distance">The labels distance.</param>
        /// <example>
        /// <code lang="CS">
        /// &lt;% Html.EasyUI().Chart()
        ///           .Name("Chart")
        ///           .Series(series => series
        ///               .Pie(p => p.Sales)
        ///               .Labels(labels => labels
        ///                   .Distance(20)
        ///                   .Visible(true)
        ///               );
        ///            )
        ///           .Render();
        /// %&gt;
        /// </code>
        /// </example>        
        public ChartPieLabelsBuilder Distance(int distance)
        {
            pieLabels.Distance = distance;
            return this;
        }

        /// <summary>
        /// Sets the labels position
        /// </summary>
        /// <param name="position">The labels position.</param>
        /// <example>
        /// <code lang="CS">
        /// &lt;% Html.EasyUI().Chart()
        ///           .Name("Chart")
        ///           .Series(series => series
        ///               .Pie(p => p.Sales)
        ///               .Labels(labels => labels
        ///                   .Position(ChartPieLabelsPosition.Center)
        ///                   .Visible(true)
        ///               );
        ///            )
        ///           .Render();
        /// %&gt;
        /// </code>
        /// </example>        
        public ChartPieLabelsBuilder Position(ChartPieLabelsPosition position)
        {
            pieLabels.Position = position;
            return this;
        }
    }
}