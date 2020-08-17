﻿// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System.Web.Mvc;
    
    class GridActionResultAdapterFactory : IGridActionResultAdapterFactory
    {
        public IGridActionResultAdapter Create(ActionResult actionResult)
        {
            var jsonResult = actionResult as JsonResult;
            
            if (jsonResult != null)
            {
                return new GridJsonResultAdapter(jsonResult);
            }

            var viewResult = actionResult as ViewResultBase;

            if (viewResult != null)
            {
                return new GridViewResultAdapter(viewResult);
            }

            return null;
        }
    }
}
