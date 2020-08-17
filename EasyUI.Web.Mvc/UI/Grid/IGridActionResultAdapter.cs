// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI
{
    using System.Collections;
    using System.Web.Mvc;

    public interface IGridActionResultAdapter
    {
        IEnumerable GetDataSource();

        int GetTotal();

        ModelStateDictionary GetModelState();

        object GetAggregates();
    }
}
