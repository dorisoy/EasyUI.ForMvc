// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    using System;
    using System.Collections.Generic;
    
    public interface IGridButtonBuilder
    {
        string SpriteCssClass
        {
            get;
            set;
        }

        IHtmlNode Create(object dataItem);

        string Text
        {
            get;
            set;
        }

        Func<object, string> Url
        {
            get;
            set;
        }

        string CssClass
        {
            get;
            set;
        }

        IDictionary<string, object> HtmlAttributes
        {
            get;
            set;
        }

        IDictionary<string, object> ImageHtmlAttributes
        {
            get;
            set;
        }

        IList<IGridButtonBuilderDecorator> Decorators
        {
            get;
        }
    }
}