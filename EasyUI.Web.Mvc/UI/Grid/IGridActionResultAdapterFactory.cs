// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System.Web.Mvc;
    
    public interface IGridActionResultAdapterFactory
    {
        IGridActionResultAdapter Create(ActionResult actionResult);
    }
}
