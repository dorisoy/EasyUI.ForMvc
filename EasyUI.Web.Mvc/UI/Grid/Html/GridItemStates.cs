// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using System;
    
    [Flags]
    public enum GridItemStates
    {
        Default     = 1 << 0,
        Master      = 1 << 1,
        Selected    = 1 << 2,
        Alternating = 1 << 3
    }
}
