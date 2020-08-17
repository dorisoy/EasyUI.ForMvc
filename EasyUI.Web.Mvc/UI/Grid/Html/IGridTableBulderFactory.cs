
// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    using System.Collections.Generic;
    
    public interface IGridTableBulderFactory
    {
        IGridTableBuilder CreateTableBuilder(IEnumerable<GridColData> colsData);
        IGridTableBuilder CreateDecoratedTableBuilder(IEnumerable<GridColData> colsData, GridRenderingData renderingData);
    }
}