namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    using System.Collections.Generic;
    using System.IO;
    using EasyUI.Web.Mvc.Extensions;

    internal class WebAssetLocator : IWebAssetLocator
    {
        private readonly IVirtualPathProvider virtualPathProvider;
        private readonly ICache cache;
        private readonly IWebAssetExtensions extensions;

        public WebAssetLocator(ICache cache, IVirtualPathProvider virtualPathProvider, IWebAssetExtensions extensions)
        {
            this.virtualPathProvider = virtualPathProvider;
            this.cache = cache;
            this.extensions = extensions;
        }

        public string Locate(string virtualPath, string version)
        {
            if (virtualPath.IndexOf("://") > -1)
            {
                return virtualPath;
            }

            return cache.Get("{0}:{1}".FormatWith(virtualPath, version), () => Resolve(virtualPath, version));
        }

        private string Resolve(string virtualPath, string version)
        {
            string extension = virtualPathProvider.GetExtension(virtualPath);

            if (extension.IsCaseInsensitiveEqual(".js"))
            {
                return ProbePath(virtualPath, version, extensions.JavaScript);
            }
            
            if (extension.IsCaseInsensitiveEqual(".css"))
            {
                return ProbePath(virtualPath, version, extensions.Css);
            }

            if (extension.IsCaseInsensitiveEqual(".eot") || extension.IsCaseInsensitiveEqual(".svg") || extension.IsCaseInsensitiveEqual(".ttf") || extension.IsCaseInsensitiveEqual(".woff"))
            {
                return ProbePath(virtualPath, version, extensions.Font);
            }

            return virtualPath;
        }

        private bool TryPath(string path, string modifier, out string result)
        {
            var directory = virtualPathProvider.GetDirectory(path);
            var fileName = virtualPathProvider.GetFile(path);
            var pathToProbe = modifier.HasValue() ? virtualPathProvider.CombinePaths(directory, modifier) + Path.AltDirectorySeparatorChar + fileName : path;

            result = virtualPathProvider.FileExists(pathToProbe) ? pathToProbe : null;

            return result != null;
        }

        private string ProbePath(string virtualPath, string version, IEnumerable<string> extensions)
        {
            foreach (var modifier in new[] { version, "" })
            {
                foreach (var extension in extensions)
                {
                    var changedPath = Path.ChangeExtension(virtualPath, extension);

                    string result = null;

                    if (TryPath(changedPath, modifier, out result))
                    {
                        return result;
                    }
                }
            }

            throw new FileNotFoundException(Resources.TextResource.SpecifiedFileDoesNotExist.FormatWith(virtualPath));
        }
    }
}