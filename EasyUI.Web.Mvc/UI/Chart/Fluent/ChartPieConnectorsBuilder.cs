﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{
    /// <summary>
    /// Defines the fluent interface for configuring the chart connectors.
    /// </summary>
    public class ChartPieConnectorsBuilder
    {
        private readonly ChartPieConnectors pieConnectors;

        /// <summary>
        /// Initializes a new instance of the <see cref="ChartPieConnectosBuilder" /> class.
        /// </summary>
        /// <param name="chartBarLabels">The connectors configuration.</param>
        public ChartPieConnectorsBuilder(ChartPieConnectors pieConnectors)
        {
            this.pieConnectors = pieConnectors;
        }

        /// <summary>
        /// Sets the connectors width
        /// </summary>
        /// <param name="width">The connectors width.</param>
        /// <example>
        /// <code lang="CS">
        /// &lt;% Html.EasyUI().Chart()
        ///           .Name("Chart")
        ///           .Series(series => series
        ///               .Pie(p => p.Sales)
        ///               .Connectors(c => c
        ///                   .Width(3)
        ///               );
        ///            )
        ///           .Render();
        /// %&gt;
        /// </code>
        /// </example>        
        public ChartPieConnectorsBuilder Width(int width)
        {
            pieConnectors.Width = width;
            return this;
        }

        /// <summary>
        /// Sets the connectors color
        /// </summary>
        /// <param name="color">The connectors color.</param>
        /// <example>
        /// <code lang="CS">
        /// &lt;% Html.EasyUI().Chart()
        ///           .Name("Chart")
        ///           .Series(series => series
        ///               .Pie(p => p.Sales)
        ///               .Connectors(c => c
        ///                   .Color(red)
        ///               );
        ///            )
        ///           .Render();
        /// %&gt;
        /// </code>
        /// </example>        
        public ChartPieConnectorsBuilder Color(string color)
        {
            pieConnectors.Color = color;
            return this;
        }

        /// <summary>
        /// Sets the connectors padding
        /// </summary>
        /// <param name="padding">The connectors padding.</param>
        /// <example>
        /// <code lang="CS">
        /// &lt;% Html.EasyUI().Chart()
        ///           .Name("Chart")
        ///           .Series(series => series
        ///               .Pie(p => p.Sales)
        ///               .Connectors(c => c
        ///                   .Padding(10)
        ///               );
        ///            )
        ///           .Render();
        /// %&gt;
        /// </code>
        /// </example>        
        public ChartPieConnectorsBuilder Padding(int padding)
        {
            pieConnectors.Padding = padding;
            return this;
        }
    }
}