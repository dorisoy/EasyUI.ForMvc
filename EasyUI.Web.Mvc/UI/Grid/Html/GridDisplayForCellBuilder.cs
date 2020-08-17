// (c) Copyright 2002-2009 EasyUI 



#if MVC2 || MVC3
namespace EasyUI.Web.Mvc.UI.Html
{
    using System;
    using System.Linq.Expressions;
    using System.Web.Mvc;
    using System.Web.Mvc.Html;
    using EasyUI.Web.Mvc.Extensions;
    
    public class GridDisplayForCellBuilder<TModel, TValue> : GridDataCellBuilderBase
             where TModel : class
    {
        public Expression<Func<TModel, TValue>> Expression
        {
            get;
            set;
        }

        public ViewContext ViewContext
        {
            get;
            set;
        }

        protected override void AppendCellContent(IHtmlNode td, object dataItem)
        {
            var htmlHelper = new HtmlHelper<TModel>(ViewContext, new GridViewDataContainer<TModel>((TModel)dataItem, ViewContext.ViewData));

            var content = htmlHelper.DisplayFor(Expression).ToHtmlString();

            content = content.HasValue() ? content : "&nbsp;";

            td.Html(content);
        }
    }
}
#endif