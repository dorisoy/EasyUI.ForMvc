namespace EasyUI.Web.Mvc.Infrastructure
{
    using System.Web;
    using System.Web.Routing;
    using EasyUI.Web.Mvc.Infrastructure.Implementation;
    using EasyUI.Web.Mvc.UI;
    using EasyUI.Web.Mvc.UI.Html;


    /// <summary>
    /// 依赖注入
    /// </summary>
    public static class DI
    {
        /// <summary>
        /// 获取或者设置当前依赖注入容器
        /// </summary>
        public static IDependencyInjectionContainer Current
        {
            get;
            set;
        }

        public static bool IsDebug
        {
            get;
            set;
        }

        static DI()
        {
            if (HttpContext.Current != null)
            {
                IsDebug = HttpContext.Current.IsDebuggingEnabled;
            }
            else
            {
                IsDebug = true;
            }

            Current = new DependencyInjectionContainer();
            
            //注册核心依赖
            RegisterCoreDependencies();
            //注册授权依赖
            RegisterAuthorizationDependencies();
            //注册额缓存依赖
            RegisterCacheDependencies();
            //注册组件依赖
            RegisterComponentDependencies();

            //Grid依赖注入引导启动
            GridDependencyBootstrapper.Setup();

            //图片浏览器依赖注入引导启动
            ImageBrowserDependencyBootstrapper.Setup();
        }

        private static void RegisterCoreDependencies()
        {
            Current.Register<IPathResolver>(() => new PathResolver());

            Current.Register<IUrlResolver>(() => new UrlResolver());

            Current.Register<IUrlGenerator>(() => new UrlGenerator());

            Current.Register<IUrlResolver>(() => new UrlResolver());

            Current.Register<IConfigurationManager>(() => new ConfigurationManagerWrapper());

            Current.Register<IWebAssetChecker>(() => new WebAssetChecker());

            Current.Register<IVirtualPathProvider>(() => new VirtualPathProviderWrapper());

            Current.Register<ILocalizationServiceFactory>(() => new LocalizationServiceFactory());

            Current.Register<IHttpResponseCacher>(() => new HttpResponseCacher());

            Current.Register<IHttpResponseCompressor>(() => new HttpResponseCompressor());

            Current.Register<IUrlAuthorization>(() => new UrlAuthorization());

            Current.Register<ISliderHtmlBuilderFactory>(() => new SliderHtmlBuilderFactory());

            Current.Register<IRangeSliderHtmlBuilderFactory>(() => new RangeSliderHtmlBuilderFactory());

            Current.Register<ScriptWrapperBase>(() => new ScriptWrapper());
        }
        private static void RegisterAuthorizationDependencies()
        {
            Current.Register<IAuthorizeAttributeBuilder>(() => new AuthorizeAttributeBuilder());


            Current.Register<IControllerAuthorization, IAuthorizeAttributeCache, IReflectedAuthorizeAttributeCache, IObjectCopier>((authorizeAttributeCache,
                reflectedAuthorizeAttributeCache, objectCopier) => new ControllerAuthorization(authorizeAttributeCache, reflectedAuthorizeAttributeCache,
                    objectCopier, RouteTable.Routes));

            Current.Register<INavigationItemAuthorization, IControllerAuthorization, IUrlAuthorization>((controllerAuthorization, urlAuthorization) =>
                new NavigationItemAuthorization(controllerAuthorization, urlAuthorization)); RegisterWebAssetDependencies();
        }
        
        private static void RegisterWebAssetDependencies()
        {
            Current.Register<IWebAssetExtensions>(() =>
            {
                if (IsDebug)
                {
                    return new DebugWebAssetExtensions();
                }

                return new ReleaseWebAssetExtensions();
            });
            
            Current.Register<IWebAssetLocator, ICacheFactory, IVirtualPathProvider, IWebAssetExtensions>((cacheFactory, provider, extensions) =>
                            new WebAssetLocator(cacheFactory.Create("locator"), provider, extensions));

            Current.Register<IWebAssetContentFilter, IVirtualPathProvider, IUrlResolver>((provider, resolver) =>
                new RebaseImagePathContentFilter(provider, resolver));

            Current.Register<IWebAssetGroupSerializer>(() => new WebAssetGroupSerializer());

            Current.Register<IWebAssetGroupReader, IWebAssetLocator, IVirtualPathProvider, IWebAssetContentFilter>((locator, provider, filter) =>
                new WebAssetGroupReader(locator, provider, filter));

            Current.Register<IWebAssetResolverFactory, IWebAssetChecker, IWebAssetLocator, IWebAssetGroupSerializer>((checker, locator, serializer) =>
                new WebAssetResolverFactory(checker, locator, serializer));

            Current.Register<IWebAssetCollectionResolver, IUrlResolver, IWebAssetResolverFactory>((urlResolver, resolverFactory) =>
                new WebAssetCollectionResolver(urlResolver, resolverFactory));
        }
        
        private static void RegisterComponentDependencies()
        {
            Current.Register<INavigationComponentHtmlBuilderFactory<PanelBar, PanelBarItem>, IActionMethodCache>((actionMethodCache) =>
                            new PanelBarHtmlBuilderFactory(actionMethodCache));

            Current.Register<INavigationComponentHtmlBuilderFactory<Menu, MenuItem>, IActionMethodCache>((actionMethodCache) =>
                new MenuHtmlBuilderFactory(actionMethodCache));

            Current.Register<ITabStripHtmlBuilderFactory, IActionMethodCache>((actionMethodCache) =>
                new TabStripHtmlBuilderFactory(actionMethodCache));

            Current.Register<ITreeViewHtmlBuilderFactory, IActionMethodCache>((actionMethodCache) =>
                new TreeViewHtmlBuilderFactory(actionMethodCache));

            Current.Register<IClientSideObjectWriterFactory>(() => new ClientSideObjectWriterFactory());
            
            Current.Register<ICalendarHtmlBuilderFactory>(() => new CalendarHtmlBuilderFactory());

            Current.Register<IWindowHtmlBuilderFactory>(() => new WindowHtmlBuilderFactory());
        }
        
        static void RegisterCacheDependencies()
        {
            Current.Register<ICacheProvider>(() => new CacheProvider());
            Current.Register<ICacheFactory, ICacheProvider>((provider) => new CacheFactory(IsDebug, provider));
            Current.Register<IReflectedAuthorizeAttributeCache, ICacheFactory, IAuthorizeAttributeBuilder>((cacheFactory, authorizeAttributeBuilder) =>
                new ReflectedAuthorizeAttributeCache(cacheFactory.Create("authorizeAttribute"), authorizeAttributeBuilder));
            Current.Register<IControllerTypeCache, ICacheFactory>((cacheFactory) => new ControllerTypeCache(cacheFactory.Create("controllerType")));
            Current.Register<IObjectCopier, IFieldCache, IPropertyCache>((fieldCache, propertyCache) => new ObjectCopier(fieldCache, propertyCache));
            Current.Register<IFieldCache, ICacheFactory>((cacheFactory) => new FieldCache(cacheFactory.Create("fields")));
            Current.Register<IPropertyCache, ICacheFactory>((cacheFactory) => new PropertyCache(cacheFactory.Create("properties")));
            Current.Register<IActionMethodCache, ICacheFactory, IControllerTypeCache>((cacheFactory, controllerTypeCache) =>
                new ActionMethodCache(cacheFactory.Create("actionMethod"), controllerTypeCache));
            Current.Register<IAuthorizeAttributeCache, ICacheFactory, IControllerTypeCache, IActionMethodCache>((cacheFactory, controllerTypeCache, actionMethodCache) =>
                new AuthorizeAttributeCache(cacheFactory.Create("authorizeAttribute"), controllerTypeCache, actionMethodCache));
        }
    }
}
