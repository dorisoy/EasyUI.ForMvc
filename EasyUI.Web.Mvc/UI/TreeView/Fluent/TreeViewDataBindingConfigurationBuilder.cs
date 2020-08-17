﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{


    /// <summary>
    /// Defines the fluent interface for configuring the <see cref="TreeView"/> data binding.
    /// </summary>
    public class TreeViewDataBindingConfigurationBuilder : IHideObjectMembers
    {
        private readonly TreeViewDataBindingConfiguration configuration;

        /// <summary>
        /// Initializes a new instance of the <see cref="TreeViewDataBindingConfigurationBuilder"/> class.
        /// </summary>
        /// <param name="settings">The configuration.</param>
        public TreeViewDataBindingConfigurationBuilder(TreeViewDataBindingConfiguration configuration)
        {
            this.configuration = configuration;
        }

        /// <summary>
        /// Use it to configure Ajax binding.
        /// </summary>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().TreeView()
        ///             .Name("TreeView")
        ///             .DataBinding(dataBinding => dataBinding
        ///                .Ajax().Select("_AjaxLoading", "TreeView")
        ///             )
        /// %&gt;
        /// </code>
        /// </example>
        public virtual TreeViewBindingSettingsBuilder Ajax()
        {
            configuration.Ajax.Enabled = true;
            
            return new TreeViewBindingSettingsBuilder(configuration.Ajax);
        }

        /// <summary>
        /// Use it to configure web service binding.
        /// </summary>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().TreeView()
        ///             .Name("TreeView")
        ///             .DataBinding(dataBinding => dataBinding
        ///                .WebService().Select("~/Models/Employees.asmx/GetEmployees")
        ///             )
        /// %&gt;
        /// </code>
        /// </example>
        public virtual TreeViewWebServiceBindingSettingsBuilder WebService()
        {
            configuration.WebService.Enabled = true;

            return new TreeViewWebServiceBindingSettingsBuilder(configuration.WebService);
        }
    }
}
