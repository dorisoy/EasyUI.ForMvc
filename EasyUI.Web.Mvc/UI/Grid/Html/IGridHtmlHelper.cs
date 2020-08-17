﻿// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    using System.Collections.Generic;
    using System;

    public interface IGridHtmlHelper
    {
        IHtmlNode HiddenForDataKey(object dataItem);

        IHtmlNode EditorForModel(object dataItem, string templateName, IEnumerable<Action<IDictionary<string, object>, object>> foreignKeyData, object additionalViewData);
    }
}
