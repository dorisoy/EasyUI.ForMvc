// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    internal class WebAssetResolverFactory : IWebAssetResolverFactory
    {
        private readonly IWebAssetChecker checker;
        private readonly IWebAssetGroupSerializer serializer;
        private readonly IWebAssetLocator locator;

        public WebAssetResolverFactory(IWebAssetChecker checker, IWebAssetLocator locator, IWebAssetGroupSerializer serializer)
        {
            this.checker = checker;
            this.locator = locator;
            this.serializer = serializer;
        }

        public IWebAssetResolver Create(IWebAsset asset)
        {
            if (asset is WebAsset)
            {
                return CreateAssetResolver((WebAsset)asset);
            }

            return CreateAssetGropResolver((WebAssetGroup)asset);
        }

        private IWebAssetResolver CreateAssetResolver(WebAsset asset)
        {
            if (checker.IsAbsolute(asset))
            {
                return new AbsoluteWebAssetResolver(asset);
            }

            if (asset.UseEasyUIContentDeliveryNetwork)
            {
                if (checker.IsNative(asset))
                {
                    return new CdnWebAssetResolver(asset);
                }
            }

            return new LocalWebAssetResolver(asset, locator);
        }

        private IWebAssetResolver CreateAssetGropResolver(WebAssetGroup group)
        {
            if (group.Combined)
            {
                return new CombinedWebAssetGroupResolver(group, this, checker, serializer);
            }

            return new WebAssetGroupResolver(group, this);
        }
    }
}
