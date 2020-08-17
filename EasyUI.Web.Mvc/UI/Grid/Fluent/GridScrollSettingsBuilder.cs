




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using Infrastructure;

    /// <summary>
    /// Defines the fluent interface for configuring <see cref="Grid{T}.Scrolling"/>
    /// </summary>
    public class GridScrollSettingsBuilder : IHideObjectMembers
    {
        private readonly GridScrollingSettings settings;

        /// <summary>
        /// Initializes a new instance of the <see cref="GridScrollSettingsBuilder"/> class.
        /// </summary>
        /// <param name="settings">The settings.</param>
        public GridScrollSettingsBuilder(GridScrollingSettings settings)
        {
            this.settings = settings;
        }

        /// <summary>
        /// Enables or disables scrolling.
        /// </summary>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Grid(Model)
        ///             .Name("Grid")
        ///             .Scrolling(scrolling => scrolling.Enabled((bool)ViewData["enableScrolling"]))
        /// %&gt;
        /// </code>
        /// </example>
        /// <remarks>
        /// The Enabled method is useful when you need to enable scrolling based on certain conditions.
        /// </remarks>
        public virtual GridScrollSettingsBuilder Enabled(bool value)
        {
            settings.Enabled = value;

            return this;
        }

        /// <summary>
        /// Sets the height of the scrollable area in pixels.
        /// </summary>
        /// <param name="pixelHeight">The height in pixels.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Grid(Model)
        ///             .Name("Grid")
        ///             .Scrolling(scrolling => scrolling.Height(400))
        /// %&gt;
        /// </code>
        /// </example>
        public virtual GridScrollSettingsBuilder Height(int pixelHeight)
        {
            Guard.IsNotNegative(pixelHeight, "pixelHeight");

            settings.Height = pixelHeight + "px";

            return this;
        }

        /// <summary>
        /// Sets the height of the scrollable.
        /// </summary>
        /// <param name="value">The height in pixels.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Grid(Model)
        ///             .Name("Grid")
        ///             .Scrolling(scrolling => scrolling.Height("20em"))
        /// %&gt;
        /// </code>
        /// </example>
        public virtual GridScrollSettingsBuilder Height(string value)
        {
            settings.Height = value;

            return this;
        }        
    }
}