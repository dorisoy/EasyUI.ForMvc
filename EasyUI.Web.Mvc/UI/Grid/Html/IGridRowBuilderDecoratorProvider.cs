// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridRowBuilderDecoratorProvider
    {
        IGridRowBuilder ApplyDecorators(IGridRowBuilder gridRowBuilder, GridItem item, bool hasDetailView);
    }
}