// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System;

    public class DirectoryPermission : IDirectoryPermission
    {
        public bool CanAccess(string rootPath, string childPath)
        {
            return childPath.StartsWith(rootPath, StringComparison.OrdinalIgnoreCase);
        }
    }
}