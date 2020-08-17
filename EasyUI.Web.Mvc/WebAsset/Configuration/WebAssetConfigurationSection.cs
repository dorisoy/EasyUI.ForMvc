




namespace EasyUI.Web.Mvc.Configuration
{
    using System.Configuration;
    using EasyUI.Web.Mvc.Infrastructure;

    /*
    <configSections>
        <sectionGroup name="EasyUI">
            <section name="webAssets" type="EasyUI.Web.Mvc.Configuration.WebAssetConfigurationSection, EasyUI.Web.Mvc"/>
        </sectionGroup>
    </configSections>
    <EasyUI>
        <webAssets useEasyUIContentDeliveryNetwork="true">
            <styleSheets>
                <add name="" defaultPath="" contentDeliveryNetworkUrl="">
                    <items>
                        <add source=""/>
                        <add source=""/>
                        <add source=""/>
                    </items>
                </add>
            </styleSheets>
            <scripts>
                <add name="" defaultPath="" contentDeliveryNetworkUrl="">
                    <items>
                        <add source=""/>
                        <add source=""/>
                        <add source=""/>
                    </items>
                </add>
            </scripts>
        </webAssets>
    </EasyUI>
    */

    /// <summary>
    /// The web asset Configuration.
    /// </summary>
    public class WebAssetConfigurationSection : ConfigurationSection
    {
        private static string sectionName = "EasyUI/webAssets";

        /// <summary>
        /// Gets the name of the section.
        /// </summary>
        /// <value>The name of the section.</value>
        public static string SectionName
        {
            get
            {
                return sectionName;
            }

            set
            {
                Guard.IsNotNullOrEmpty(value, "value");

                sectionName = value;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether to use EasyUI content delivery network.
        /// </summary>
        /// <value>
        /// <c>true</c> if [use EasyUI content delivery network]; otherwise, <c>false</c>.
        /// </value>
        [ConfigurationProperty("useEasyUIContentDeliveryNetwork")]
        public bool UseEasyUIContentDeliveryNetwork
        {
            get
            {
                return (bool)this["useEasyUIContentDeliveryNetwork"];
            }

            set
            {
                this["useEasyUIContentDeliveryNetwork"] = value;
            }
        }

        /// <summary>
        /// Gets the style sheets.
        /// </summary>
        /// <value>The style sheets.</value>
        [ConfigurationProperty("styleSheets")]
        public WebAssetGroupConfigurationElementCollection StyleSheets
        {
            get
            {
                return (WebAssetGroupConfigurationElementCollection) base["styleSheets"] ?? new WebAssetGroupConfigurationElementCollection();
            }
        }

        /// <summary>
        /// Gets the scripts.
        /// </summary>
        /// <value>The scripts.</value>
        [ConfigurationProperty("scripts")]
        public WebAssetGroupConfigurationElementCollection Scripts
        {
            get
            {
                return (WebAssetGroupConfigurationElementCollection) base["scripts"] ?? new WebAssetGroupConfigurationElementCollection();
            }
        }
    }
}