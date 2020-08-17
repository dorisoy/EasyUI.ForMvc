﻿// (c) Copyright 2002-2011 EasyUI 



#if MVC2 || MVC3
namespace EasyUI.Web.Mvc.UI.Html
{
    using System;
    using System.Collections.Generic;

    public class GridForeignKeyEditorForCellBuilder<TModel, TValue> : GridEditorForCellBuilder<TModel, TValue>
             where TModel : class
    {
        public Action<IDictionary<string, object>, object> AppendViewData
        {
            get;
            set;
        }

        protected override void AppendCellContent(IHtmlNode td, object dataItem)
        {
            AppendViewData(ViewContext.ViewData, dataItem);
            base.AppendCellContent(td, dataItem);
        }       
    }
}

#endif
