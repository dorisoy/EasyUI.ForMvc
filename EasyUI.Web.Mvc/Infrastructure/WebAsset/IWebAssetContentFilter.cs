// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.Infrastructure
{
    public interface IWebAssetContentFilter
    {
        bool AppliesTo(string contentType);
        string Filter(string basePath, string content);
    }
}