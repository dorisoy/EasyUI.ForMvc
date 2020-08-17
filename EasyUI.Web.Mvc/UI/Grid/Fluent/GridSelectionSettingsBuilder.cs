﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{
    /// <summary>
    ///  Defines the fluent interface for configuring <see cref="Grid{T}.Selection"/>
    /// </summary>
    public class GridSelectionSettingsBuilder : IHideObjectMembers
    {
        private readonly GridSelectionSettings settings;

        public GridSelectionSettingsBuilder(GridSelectionSettings settings)
        {
            this.settings = settings;
        }

        /// <summary>
        /// Enables or disables selection.
        /// </summary>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Grid(Model)
        ///             .Name("Grid")
        ///             .Selectable(selection => selection.Enabled((bool)ViewData["enableSelection"]))
        /// %&gt;
        /// </code>
        /// </example>
        /// <remarks>
        /// The Enabled method is useful when you need to enable scrolling based on certain conditions.
        /// </remarks>
        public void Enabled(bool value)
        {
            settings.Enabled = value;
        }
    }
}
