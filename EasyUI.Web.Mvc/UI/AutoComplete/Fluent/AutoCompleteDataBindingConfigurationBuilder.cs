﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{
    /// <summary>
    /// Defines the fluent interface for configuring the <see cref="AutoCompleteDataBindingConfiguration"/> data binding.
    /// </summary>
    public class AutoCompleteDataBindingConfigurationBuilder : IHideObjectMembers
    {
        private readonly IDropDownDataBindingConfiguration configuration;

        /// <summary>
        /// Initializes a new instance of the <see cref="AutoCompleteDataBindingConfigurationBuilder"/> class.
        /// </summary>
        /// <param name="settings">The configuration.</param>
        public AutoCompleteDataBindingConfigurationBuilder(IDropDownDataBindingConfiguration configuration)
        {
            this.configuration = configuration;
        }

        /// <summary>
        /// Use it to configure Ajax binding.
        /// </summary>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().ComboBox()
        ///             .Name("ComboBox")
        ///             .DataBinding(dataBinding => dataBinding
        ///                .Ajax().Select("_AjaxLoading", "TreeView")
        ///             )
        /// %&gt;
        /// </code>
        /// </example>
        public AutoCompleteBindingSettingsBuilder Ajax()
        {
            configuration.Ajax.Enabled = true;

            return new AutoCompleteBindingSettingsBuilder(configuration.Ajax as AutoCompleteBindingSettings);
        }

        /// <summary>
        /// Use it to configure web service binding.
        /// </summary>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().ComboBox()
        ///             .Name("ComboBox")
        ///             .DataBinding(dataBinding => dataBinding
        ///                .WebService().Select("~/Models/ProductDDI.asmx/GetProducts")
        ///             )
        /// %&gt;
        /// </code>
        /// </example>
        public AutoCompleteWebServiceBindingSettingsBuilder WebService()
        {
            configuration.WebService.Enabled = true;

            return new AutoCompleteWebServiceBindingSettingsBuilder(configuration.WebService as AutoCompleteBindingSettings);
        }
    }
}
