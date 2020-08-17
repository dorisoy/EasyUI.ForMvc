
namespace EasyUI.Web.Mvc
{
    using System.Reflection;
    using EasyUI.Web.Mvc.Configuration;
    using EasyUI.Web.Mvc.Infrastructure;

    /// <summary>
    /// ����Ĭ����Դ����
    /// </summary>
    public static class WebAssetDefaultSettings
    {
        //���ݷַ�����
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

        //��ʽ����·��
        private static string styleSheetFilesPath = "~/Content";
        //�ű�����·��
        private static string scriptFilesPath = "~/Scripts";
        //��������·��
        private static string fontsFilesPath = "~/Fonts";
        //
        private static string version = new AssemblyName(typeof (WebAssetDefaultSettings).Assembly.FullName).Version.ToString(3);
        //�Ƿ�ѹ��
        private static bool compress = true;
        //�����������
        private static float cacheDurationInDays = 365f;
        //
        private static readonly object useEasyUICdnLock = new object();
        //
        private static bool? useEasyUICdn;

        /// <summary>
        /// ��ȡ�����ø���ʽ���ļ���·����·��������һ������·��.
        /// </summary>
        /// <value>�ļ�·��.</value>
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
        /// ��ȡ�����øýű��ļ���·����·��������һ������·��.
        /// </summary>
        /// <value>�ļ�·��.</value>
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
        /// ��ȡ�����ø������ļ���·����·��������һ������·��.
        /// </summary>
        /// <value>�ļ�·��.</value>
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
        /// �汾.
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
        /// �Ƿ�Ӧ��Ϊѹ����Դ.
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
        /// �Ƿ�����ϲ�.
        /// </summary>
        /// <value><c>true</c> if combined; otherwise, <c>false</c>.</value>
        public static bool Combined
        {
            get;
            set;
        }

        /// <summary>
        /// �����������.
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
        /// ʹ�����ݷַ�CDN
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