// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridItemCreator
    {
        GridItem CreateItem(object dataItem);

        GridItem CreateInsertItem();

        GridItem CreateGroupFooterItem(object dataItem);
    }
}