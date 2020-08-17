// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    public interface IGridLocalization
    {
        string CancelChanges { get; }

        string SaveChanges { get; }

        string Select 
        { 
            get; 
        }

        string GroupHint
        {
            get;
        }
        
        string AddNew
        {
            get;
        }

        string Insert
        {
            get;
        }

        string Update
        {
            get;
        }
        
        string Edit
        {
            get;
        }
        
        string Delete
        {
            get;
        }
        
        string Cancel
        {
            get;
        }
    }
}