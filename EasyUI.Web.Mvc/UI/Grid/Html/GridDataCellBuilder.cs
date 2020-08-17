﻿// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using System;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.UI;

    public class GridDataCellBuilder<TModel, TValue> : GridDataCellBuilderBase, IGridFormatableCellBuilder
        where TModel : class
    {
        public Func<TModel, TValue> Value
        {
            get;
            set;
        }

        public string Format
        {
            get;
            set;
        }

        public bool Encoded
        {
            get;
            set;
        }

        protected override void AppendCellContent(IHtmlNode td, object dataItem)
        {
            object value = null;

            if (dataItem != null)
            {
                value = Value((TModel)dataItem);
            }

            if (value != null)
            {
                SetCellContent(td, ApplyFormat(value));
            }
            else
            {
                td.Html("&nbsp;");
            }
        }

        protected void SetCellContent(IHtmlNode td, string content)
        {
            if (Encoded)
            {
                td.Text(content);
            }
            else
            {
                td.Html(content);
            }
        }

        protected string ApplyFormat(object value)
        {
            return Format.HasValue() ? Format.FormatWith(value) : value.ToString();
        }
    }
}
