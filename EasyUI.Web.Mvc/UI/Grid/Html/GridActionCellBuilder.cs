// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using System;
    using System.Collections.Generic;
    
    public class GridActionCellBuilder : GridDataCellBuilderBase
    {
        private readonly IEnumerable<Func<object, IHtmlNode>> builders;

        public GridActionCellBuilder(IEnumerable<Func<object, IHtmlNode>> builders)
        {
            this.builders = builders;
        }

        protected override void AppendCellContent(IHtmlNode td, object dataItem)
        {
            foreach (var builder in builders)
            {
                builder(dataItem).AppendTo(td);
            }
        }
    }
}