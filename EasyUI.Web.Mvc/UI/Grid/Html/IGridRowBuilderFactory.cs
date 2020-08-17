// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridRowBuilderFactory
    {
        IGridRowBuilder CreateBuilder(GridRenderingData renderingData, GridItem item);

        IGridRowBuilder CreateHeaderBuilder(GridRenderingData renderingData);
        
        IGridRowBuilder CreateFooterBuilder(GridRenderingData renderingData);
    }
}
