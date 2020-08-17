




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using System.Web;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Infrastructure;

    /// <summary>
    /// HTMLHelper extension for providing access to <see cref="ViewComponentFactory"/>.
    /// </summary>
    public static class HtmlHelperExtension
    {
        private static readonly string Key = typeof(ViewComponentFactory).AssemblyQualifiedName;

        /// <summary>
        /// Gets the EasyUI View Component Factory
        /// </summary>
        /// <param name="helper">The helper.</param>
        /// <returns>The Factory</returns>
        public static ViewComponentFactory EasyUI(this HtmlHelper helper)
        {
            Guard.IsNotNull(helper, "helper");

            ViewContext viewContext = helper.ViewContext;
            HttpContextBase httpContext = viewContext.HttpContext;
            
            ScriptWrapperBase scriptWrapper = DI.Current.Resolve<ScriptWrapperBase>();
            IClientSideObjectWriterFactory clientSideObjectWriterFactory = DI.Current.Resolve<IClientSideObjectWriterFactory>();

            StyleSheetRegistrar styleSheetRegistrar = httpContext.Items[StyleSheetRegistrar.Key] as StyleSheetRegistrar ??
                                                        new StyleSheetRegistrar(new WebAssetCollection(WebAssetDefaultSettings.StyleSheetFilesPath), viewContext, DI.Current.Resolve<IWebAssetCollectionResolver>());
            ScriptRegistrar scriptRegistrar = httpContext.Items[ScriptRegistrar.Key] as ScriptRegistrar ??
                                                        new ScriptRegistrar(new WebAssetCollection(WebAssetDefaultSettings.ScriptFilesPath), new List<IScriptableComponent>(), viewContext, DI.Current.Resolve<IWebAssetCollectionResolver>(), scriptWrapper);

            StyleSheetRegistrarBuilder styleSheetRegistrarBuilder = StyleSheetRegistrarBuilder.Create(styleSheetRegistrar);
            ScriptRegistrarBuilder scriptRegistrarBuilder = ScriptRegistrarBuilder.Create(scriptRegistrar);

            return new ViewComponentFactory(helper, clientSideObjectWriterFactory, styleSheetRegistrarBuilder, scriptRegistrarBuilder);
        }

#if MVC2 || MVC3
        /// <summary>
        /// Gets the EasyUI View Component Factory
        /// </summary>
        /// <param name="helper">The helper.</param>
        /// <returns>The Factory</returns>
        public static ViewComponentFactory<TModel> EasyUI<TModel>(this HtmlHelper<TModel> helper)
        {
            Guard.IsNotNull(helper, "helper");

            ViewContext viewContext = helper.ViewContext;
            HttpContextBase httpContext = viewContext.HttpContext;

            ScriptWrapperBase scriptWrapper = DI.Current.Resolve<ScriptWrapperBase>();
            IClientSideObjectWriterFactory clientSideObjectWriterFactory = DI.Current.Resolve<IClientSideObjectWriterFactory>();

            StyleSheetRegistrar styleSheetRegistrar = httpContext.Items[StyleSheetRegistrar.Key] as StyleSheetRegistrar ??
                                                        new StyleSheetRegistrar(new WebAssetCollection(WebAssetDefaultSettings.StyleSheetFilesPath), viewContext, DI.Current.Resolve<IWebAssetCollectionResolver>());
            ScriptRegistrar scriptRegistrar = httpContext.Items[ScriptRegistrar.Key] as ScriptRegistrar ??
                                                        new ScriptRegistrar(new WebAssetCollection(WebAssetDefaultSettings.ScriptFilesPath), new List<IScriptableComponent>(), viewContext, DI.Current.Resolve<IWebAssetCollectionResolver>(), scriptWrapper);

            StyleSheetRegistrarBuilder styleSheetRegistrarBuilder = StyleSheetRegistrarBuilder.Create(styleSheetRegistrar);
            ScriptRegistrarBuilder scriptRegistrarBuilder = ScriptRegistrarBuilder.Create(scriptRegistrar);

            return new ViewComponentFactory<TModel>(helper, clientSideObjectWriterFactory, styleSheetRegistrarBuilder, scriptRegistrarBuilder);
        }
#endif
    }
}