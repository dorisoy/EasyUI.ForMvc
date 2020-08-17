// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    using System.Collections.Generic;
    
    internal class DebugWebAssetExtensions : IWebAssetExtensions
    {
        public IEnumerable<string> JavaScript
        {
            get
            {
                return WebAssetDefaultSettings.DebugJavaScriptExtensions;
            }
        }
        
        public IEnumerable<string> Css
        {
            get
            {
                return WebAssetDefaultSettings.DebugCssExtensions;
            }
        }

        public IEnumerable<string> Font
        {
            get
            {
                return WebAssetDefaultSettings.DebugFontExtensions;
            }
        }
    }
}
