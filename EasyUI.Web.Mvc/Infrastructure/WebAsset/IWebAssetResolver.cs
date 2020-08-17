// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.Infrastructure
{
    using System.Collections.Generic;
    
    public interface IWebAssetResolver
    {
        IEnumerable<string> Resolve(ResolverContext resolverContext);
    }
}
