// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridRowBuilderDecorator : IGridRowBuilder
    {
        void Decorate(IGridRowBuilder rowBuilder, GridItem gridItem, bool hasDetailView);
        
        bool ShouldDecorate(GridItem gridItem);
    }
}