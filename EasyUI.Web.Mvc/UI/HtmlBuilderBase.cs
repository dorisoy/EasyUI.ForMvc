﻿



namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Extensions;

    public abstract class HtmlBuilderBase : IHtmlBuilder
    {
        public HtmlBuilderBase()
        {
            Adorners = new List<IHtmlAdorner>();
        }
        
        public IHtmlNode Build()
        {
            var result = BuildCore();

            Adorners.Each(adorner => adorner.ApplyTo(result));

            return result;
        }

        protected abstract IHtmlNode BuildCore();

        public IList<IHtmlAdorner> Adorners
        {
            get;
            private set;
        }
    }
}
