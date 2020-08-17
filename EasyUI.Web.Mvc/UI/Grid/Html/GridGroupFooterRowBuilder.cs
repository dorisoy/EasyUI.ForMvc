﻿// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using System.Collections.Generic;

    public class GridGroupFooterRowBuilder : GridRowBuilder
    {
        public GridGroupFooterRowBuilder(IEnumerable<IGridCellBuilder> cellBuilders) 
            : base(cellBuilders)
        {
        }

        public override IHtmlNode CreateRow()
        {
            var tr = base.CreateRow();
            tr.AddClass(UIPrimitives.Grid.GroupFooter);
            return tr;
        }
    }
}