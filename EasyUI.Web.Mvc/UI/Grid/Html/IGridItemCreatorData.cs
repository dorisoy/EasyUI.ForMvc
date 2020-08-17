// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using System;
    
    public interface IGridItemCreatorData
    {
        bool HasDetailView
        {
            get;
        }
        
        GridItemMode Mode 
        { 
            get; 
        }

        Func<object> CreateNewDataItem
        {
            get;
            set;
        }

        bool ShowGroupFooter
        {
            get;
            set;
        }

        int GroupsCount
        {
            get;
            set;
        }
    }
}