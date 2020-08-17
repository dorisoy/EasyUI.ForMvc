﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using EasyUI.Web.Mvc.Infrastructure;
    using System.Web;

    public class SliderTooltipBuilder : IHideObjectMembers
    {
        private readonly SliderTooltipSettings settings;

        public SliderTooltipBuilder(SliderTooltipSettings settings)
        {
            Guard.IsNotNull(settings, "settings");

            this.settings = settings;
        }

        /// <summary>Gets or sets the format for displaying the value in the tooltip.</summary>
        /// <param name="value">The value.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Slider()
        ///             .Name("Slider")
        ///             .Tooltip(tooltip => tooltip.Format("{0:P"))
        /// %&gt;
        /// </code>
        /// </example>
        public SliderTooltipBuilder Format(string value)
        {
            // Doing the UrlDecode to allow {0} in ActionLink e.g. Html.ActionLink("Index", "Home", new { id = "{0}" })
            settings.Format = HttpUtility.UrlDecode(value);

            return this;
        }

        /// <summary>Display tooltip while drag.</summary>
        /// <param name="value">The value.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Slider()
        ///             .Name("Slider")
        ///             .Tooltip(tooltip => tooltip.Enable(false))
        /// %&gt;
        /// </code>
        /// </example>
        public SliderTooltipBuilder Enabled(bool value)
        {
            settings.Enabled = value;

            return this;
        }
    }
}