// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System.Web.Mvc;
    
    class GridActionResultFactory : IGridActionResultFactory
    {
        public ActionResult Create(object model)
        {
            return new JsonResult
            {
                Data = model
            };
        }
    }
}