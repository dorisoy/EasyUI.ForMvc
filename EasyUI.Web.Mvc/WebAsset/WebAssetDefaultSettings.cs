
namespace EasyUI.Web.Mvc
{
    using System.Reflection;
    using EasyUI.Web.Mvc.Configuration;
    using EasyUI.Web.Mvc.Infrastructure;

    /// <summary>
    /// 包含默认资源配置
    /// </summary>
    public static class WebAssetDefaultSettings
    {
        //内容分发网络
        public const string EasyUIContentDeliveryNetworkStyleSheetUrl = "http://aspnet-skins.easyuistatic.com";
        public const string EasyUIContentDeliveryNetworkSecureStyleSheetUrl = "https://easyui-aspnet-skins.s3.amazonaws.com";
        public const string EasyUIContentDeliveryNetworkScriptUrl = "http://aspnet-scripts.easyuistatic.com";
        public const string EasyUIContentDeliveryNetworkSecureScriptUrl = "https://easyui-aspnet-scripts.s3.amazonaws.com";
        
        public static string[] DebugJavaScriptExtensions = new[] { ".debug.js", ".js", ".min.js" };
        public static string[] ReleaseJavaScriptExtensions = new[] { ".min.js", ".js", ".debug.js" };
        public static string[] DebugCssExtensions = new[] { ".css", ".min.css" };
        public static string[] ReleaseCssExtensions = new[] { ".min.css", ".css" };

        public static string[] DebugFontExtensions = new[] { ".eot", ".svg", ".ttf", ".woff"};
        public static string[] ReleaseFontExtensions = new[] { ".eot", ".svg", ".ttf", ".woff" };

        //样式所在路劲
        private static string styleSheetFilesPath = "~/Content";
        //脚本所在路劲
        private static string scriptFilesPath = "~/Scripts";
        //字体所在路劲
        private static string fontsFilesPath = "~/Fonts";
        //
        private static string version = new AssemblyName(typeof (WebAssetDefaultSettings).Assembly.FullName).Version.ToString(3);
        //是否压缩
        private static bool compress = true;
        //缓存持续天数
        private static float cacheDurationInDays = 365f;
        //
        private static readonly object useEasyUICdnLock = new object();
        //
        private static bool? useEasyUICdn;

        /// <summary>
        /// 获取或设置该样式表文件的路径。路径必须是一个虚拟路径.
        /// </summary>
        /// <value>文件路劲.</value>
        public static string StyleSheetFilesPath
        {
            get
            {
                return styleSheetFilesPath;
            }

            set
            {
                Guard.IsNotVirtualPath(value, "value");

                styleSheetFilesPath = value;
            }
        }

        /// <summary>
        /// 获取或设置该脚本文件的路径。路径必须是一个虚拟路径.
        /// </summary>
        /// <value>文件路劲.</value>
        public static string ScriptFilesPath
        {
            get
            {
                return scriptFilesPath;
            }

            set
            {
                Guard.IsNotVirtualPath(value, "value");

                scriptFilesPath = value;
            }
        }

        /// <summary>
        /// 获取或设置该字体文件的路径。路径必须是一个虚拟路径.
        /// </summary>
        /// <value>文件路劲.</value>
        public static string FontsFilesPath
        {
            get
            {
                return fontsFilesPath;
            }

            set
            {
                Guard.IsNotVirtualPath(value, "value");

                fontsFilesPath = value;
            }
        }



        /// <summary>
        /// 版本.
        /// </summary>
        /// <value>The version.</value>
        public static string Version
        {
            get
            {
                return version;
            }

            set
            {
                version = value;
            }
        }

        /// <summary>
        /// 是否应作为压缩资源.
        /// </summary>
        /// <value><c>true</c> if compress; otherwise, <c>false</c>.</value>
        public static bool Compress
        {
            get
            {
                return compress;
            }
            set
            {
                compress = value;
            }
        }

        /// <summary>
        /// 是否允许合并.
        /// </summary>
        /// <value><c>true</c> if combined; otherwise, <c>false</c>.</value>
        public static bool Combined
        {
            get;
            set;
        }

        /// <summary>
        /// 缓存持续天数.
        /// </summary>
        /// <value>The cache duration in days.</value>
        public static float CacheDurationInDays
        {
            get
            {
                return cacheDurationInDays;
            }

            set
            {
                Guard.IsNotNegative(value, "value");
                cacheDurationInDays = value;
            }
        }

        /// <summary>
        /// 使用类容分发CDN
        /// </summary>
        /// <value>
        /// <c>true</c> if [use EasyUI content delivery network]; otherwise, <c>false</c>.
        /// </value>
        public static bool UseEasyUIContentDeliveryNetwork
        {
            get
            {
                if (!useEasyUICdn.HasValue)
                {
                    lock (useEasyUICdnLock)
                    {
                        if (!useEasyUICdn.HasValue)
                        {
                            WebAssetConfigurationSection section = null;

                            if (DI.Current != null)
                            {
                                IConfigurationManager configurationManager = DI.Current.Resolve<IConfigurationManager>();

                                if (configurationManager != null)
                                {
                                    section = configurationManager.GetSection<WebAssetConfigurationSection>(WebAssetConfigurationSection.SectionName);
                                }
                            }

                            useEasyUICdn = (section != null) && section.UseEasyUIContentDeliveryNetwork;
                        }
                    }
                }

                return useEasyUICdn ?? false;
            }

            set
            {
                useEasyUICdn = value;
            }
        }
    }
}