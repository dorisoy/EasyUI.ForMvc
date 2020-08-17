// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.Infrastructure
{
    using System.Collections.Generic;
    
    public interface IWebAssetExtensions
    {
        IEnumerable<string> JavaScript
        {
            get;
        }
        
        IEnumerable<string> Css
        {
            get;
        }

        IEnumerable<string> Font
        {
            get;
        }
    }
}
