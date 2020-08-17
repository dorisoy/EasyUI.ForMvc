namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.IO;
    using UI;

    /// <summary>
    /// Represents a simple implementation of per-user based storage by extending the default 
    /// <see ref="EditorFileBrowserController" /> implementation
    /// </summary>
    public class ImageBrowserController : EditorFileBrowserController
    {
        private const string contentFolderRoot = "~/Content/";
        private const string prettyName = "Images/";
        private static readonly string[] foldersToCopy = new[] { "~/Content/Images" };

        /// <summary>
        /// Gets the base paths from which content will be served.
        /// </summary>
        public override string[] ContentPaths
        {
            get
            {
                return new[] {CreateUserFolder()};
            }
        }

        private string UserID
        {
            get { 
                var obj = Session["UserID"];
                if (obj == null)
                {
                    Session["UserID"] = obj = DateTime.Now.Ticks.ToString();
                }
                return (string)obj;
            }
        }
        
        private string CreateUserFolder()
        {
            var userFolder = Path.Combine("UserFiles", UserID);
            var virtualPath = Path.Combine(contentFolderRoot, userFolder, prettyName);

            var path = Server.MapPath(virtualPath);
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
                foreach (var sourceFolder in foldersToCopy)
                {
                    CopyFolder(Server.MapPath(sourceFolder), path);
                }
            }
            return virtualPath;
        }

        private void CopyFolder(string source, string destination)
        {
            if (!Directory.Exists(destination))
            {
                Directory.CreateDirectory(destination);
            }

            foreach (var file in Directory.EnumerateFiles(source))
            {
                var dest = Path.Combine(destination, Path.GetFileName(file));
                System.IO.File.Copy(file, dest);
            }

            foreach (var folder in Directory.EnumerateDirectories(source))
            {
                var dest = Path.Combine(destination, Path.GetFileName(folder));
                CopyFolder(folder, dest);
            }
        }
    }
}
