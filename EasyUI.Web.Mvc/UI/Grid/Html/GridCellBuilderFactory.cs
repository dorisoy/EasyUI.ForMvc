// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.UI;

    public class GridCellBuilderFactory : IGridCellBuilderFactory
    {
        public IGridDataCellBuilder CreateDisplayCellBuilder(IGridColumn column, IGridHtmlHelper htmlHelper)
        {
            return column.CreateDisplayBuilder(htmlHelper);
        }

        public IGridDataCellBuilder CreateEditCellBuilder(IGridColumn column, IGridHtmlHelper htmlHelper)
        {
            return column.CreateEditBuilder(htmlHelper);
        }

        public IGridDataCellBuilder CreateInsertCellBuilder(IGridColumn column, IGridHtmlHelper htmlHelper)
        {
            return column.CreateInsertBuilder(htmlHelper);
        }

        public IGridCellBuilder CreateHeaderCellBuilder(IGridColumn column)
        {
            return column.CreateHeaderBuilder();
        }
        
        public IGridCellBuilder CreateFooterCellBuilder(IGridColumn column, IEnumerable<AggregateResult> aggregatesResults)
        {
            return column.CreateFooterBuilder(aggregatesResults);
        }

        public IGridCellBuilder CreateGroupFooterCellBuilder(IGridColumn column, IEnumerable<AggregateResult> aggregatesResults)
        {
            return column.CreateGroupFooterBuilder(aggregatesResults);
        }
    }
}
