﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{


    /// <summary>
    /// Defines the fluent interface for configuring the <see cref="DropDownList"/> data binding.
    /// </summary>
    public class DropDownListDataBindingConfigurationBuilder : IHideObjectMembers
    {
        private readonly IDropDownDataBindingConfiguration configuration;

        /// <summary>
        /// Initializes a new instance of the <see cref="DropDownDataBindingConfigurationBuilder"/> class.
        /// </summary>
        /// <param name="settings">The configuration.</param>
        public DropDownListDataBindingConfigurationBuilder(IDropDownDataBindingConfiguration configuration)
        {
            this.configuration = configuration;
        }

        /// <summary>
        /// Use it to configure Ajax binding.
        /// </summary>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().DropDownList()
        ///             .Name("DropDownList")
        ///             .DataBinding(dataBinding => dataBinding
        ///                .Ajax().Select("_AjaxLoading", "TreeView")
        ///             )
        /// %&gt;
        /// </code>
        /// </example>
        public DropDownListBindingSettingsBuilder Ajax()
        {
            configuration.Ajax.Enabled = true;

            return new DropDownListBindingSettingsBuilder(configuration.Ajax);
        }

        /// <summary>
        /// Use it to configure web service binding.
        /// </summary>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().DropDownList()
        ///             .Name("DropDownList")
        ///             .DataBinding(dataBinding => dataBinding
        ///                .WebService().Select("~/Models/ProductDDI.asmx/GetProducts")
        ///             )
        /// %&gt;
        /// </code>
        /// </example>
        public DropDownListWebServiceBindingSettingsBuilder WebService()
        {
            configuration.WebService.Enabled = true;

            return new DropDownListWebServiceBindingSettingsBuilder(configuration.WebService);
        }
    }
}
