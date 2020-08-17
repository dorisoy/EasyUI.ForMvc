// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System.Web.Mvc;
    
    public interface IGridActionResultFactory
    {
        ActionResult Create(object model);
    }
}
