namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.IO;
    using System.Reflection;
    using System.Runtime.CompilerServices;

    public class GetAssemblyFullName : Task
    {
        public override bool Execute()
        {
            string fullPath = Path.GetFullPath(this.AssemblyPath);
            if (!File.Exists(this.AssemblyPath))
            {
                base.Log.LogError("The file specified by the path {0} does not exist!", new object[] { fullPath });
                return false;
            }
            AssemblyName assemblyName = null;
            try
            {
                assemblyName = AssemblyName.GetAssemblyName(fullPath);
            }
            catch (ArgumentException)
            {
                base.Log.LogError("The file specified by the path {0} is not a valid assembly", new object[] { fullPath });
                return false;
            }
            this.FullName = assemblyName.FullName;
            this.Version = assemblyName.Version.ToString();
            return true;
        }

        [Required]
        public string AssemblyPath { get; set; }

        [Output]
        public string FullName { get; private set; }

        [Output]
        public string Version { get; private set; }
    }
}

