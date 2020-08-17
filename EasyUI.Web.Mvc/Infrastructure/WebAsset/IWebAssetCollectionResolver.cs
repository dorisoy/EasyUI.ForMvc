// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.Infrastructure
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.UI;

   /// <summary>
   /// Web资源集合解析器
   /// </summary>
    public interface IWebAssetCollectionResolver
    {
        /// <summary>
        /// 解析
        /// </summary>
        /// <param name="resolverContext"></param>
        /// <param name="assets"></param>
        /// <returns></returns>
        IEnumerable<string> Resolve(ResolverContext resolverContext, WebAssetCollection assets);
    }
}
