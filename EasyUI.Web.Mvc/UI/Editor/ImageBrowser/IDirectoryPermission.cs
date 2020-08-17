// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    public interface IDirectoryPermission
    {
        bool CanAccess(string rootPath, string childPath);
    }
}