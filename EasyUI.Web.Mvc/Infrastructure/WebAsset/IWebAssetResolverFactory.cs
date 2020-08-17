// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.Infrastructure
{
    public interface IWebAssetResolverFactory
    {
        IWebAssetResolver Create(IWebAsset asset);
    }
}
