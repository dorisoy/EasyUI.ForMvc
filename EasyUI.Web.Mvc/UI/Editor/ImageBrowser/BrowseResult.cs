// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;

    public class BrowseResult
    {
        public IEnumerable<DirectoryEntry> Directories
        {
            get;
            set;
        }

        public IEnumerable<FileEntry> Files
        {
            get;
            set;
        }

        public string Path
        {
            get;
            set;
        }

        public string[] ContentPaths
        {
            get;
            set;
        }
    }
}