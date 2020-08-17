// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using System.Web;

    public interface IDirectoryBrowser
    {
        IEnumerable<FileEntry> GetFiles(string path, string filter);

        IEnumerable<DirectoryEntry> GetDirectories(string path);

        HttpServerUtilityBase Server
        {
            get;
            set;
        }
    }
}