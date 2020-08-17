// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridItemCreatorFactory
    {
        IGridItemCreator Create(IGridDataKeyStore dataKeyData, IGridItemCreatorData creatorData);
    }
}