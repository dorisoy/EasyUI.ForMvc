// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    public class GridItemCreatorFactory : IGridItemCreatorFactory
    {
        public IGridItemCreator Create(IGridDataKeyStore dataKeyData, IGridItemCreatorData creatorData)
        {
            var comparer = new GridDataKeyComparer(dataKeyData.DataKeyGetters, dataKeyData.CurrentDataKeyValues);

            return new GridItemCreator(comparer, creatorData);
        }
    }
}