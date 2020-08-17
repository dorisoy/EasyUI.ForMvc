namespace EasyUI.MSBuildTasks.Web
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.IO;
    using System.Runtime.CompilerServices;
    using EasyUI.MSBuildTasks.Helpers;

    /// <summary>
    /// 获取程序集版本后缀
    /// </summary>
    public class GetAssemblyVersionSuffix : Task
    {
        /// <summary>
        /// 
        /// </summary>
        private string suffix;
        /// <summary>
        /// 执行并获取后缀
        /// </summary>
        /// <returns></returns>
        public override bool Execute()
        {
            string fullPath = Path.GetFullPath(this.AssemblyInfoFile);
            if (!File.Exists(this.AssemblyInfoFile))
            {
                base.Log.LogError("File {0} (full path: {1}) does not exist!", new object[] { this.AssemblyInfoFile, fullPath });
                return false;
            }
            AssemblyInfoParser parser = new AssemblyInfoParser(fullPath);
            DateAndFrameworkDependentVersion version = new DateAndFrameworkDependentVersion(parser.AssemblyVersion, 0);
            string separator = this.Separator ?? "_";
            this.suffix = VersionFormatter.ForFile(version.NewVersion, separator);
            return true;
        }
        /// <summary>
        /// 
        /// </summary>
        [Required]
        public string AssemblyInfoFile { get; set; }
        /// <summary>
        /// 分隔符
        /// </summary>
        public string Separator { get; set; }

        /// <summary>
        /// 获取后缀
        /// </summary>
        [Output]
        public string Suffix
        {
            get
            {
                return this.suffix;
            }
        }
    }
}

