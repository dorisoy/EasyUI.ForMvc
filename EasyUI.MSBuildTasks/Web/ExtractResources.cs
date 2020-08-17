namespace EasyUI.MSBuildTasks.Web
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.IO;
    using System.Reflection;
    using System.Text.RegularExpressions;

    /// <summary>
    /// 提取资源
    /// </summary>
    public class ExtractResources : Task
    {
        private string assemblyLoadPath;
        private string outputFolder;
        private bool overwrite;
        private string resourceNamePattern;
        private Regex resourceNameRegex;
        private string stripPrefix;

        public ExtractResources()
        {
            this.Overwrite = true;
        }

        protected virtual string ConvertResourceNameWithoutExtensionToRelativePath(string resourceNameWithoutExtension)
        {
            return resourceNameWithoutExtension.Replace(".", @"\");
        }

        public override bool Execute()
        {
            string[] manifestResourceNames;
            Assembly assembly;
            if (!File.Exists(this.AssemblyLoadPath))
            {
                base.Log.LogError(string.Format("Invalid AssemblyLoadPath", new object[0]), new object[0]);
                return false;
            }
            if (string.IsNullOrEmpty(this.ResourceNamePattern))
            {
                base.Log.LogError(string.Format("ResourceNamePattern not specified", new object[0]), new object[0]);
                return false;
            }
            if (this.ResourceNameRegex == null)
            {
                return false;
            }
            if (!Directory.Exists(this.OutputFolder))
            {
                Directory.CreateDirectory(this.OutputFolder);
            }
            try
            {
                AssemblyName assemblyName = AssemblyName.GetAssemblyName(this.AssemblyLoadPath);
                assembly = Assembly.Load(assemblyName);
                if (string.IsNullOrEmpty(this.StripPrefix))
                {
                    this.StripPrefix = assemblyName.Name + ".";
                }
                manifestResourceNames = assembly.GetManifestResourceNames();
            }
            catch (ArgumentException)
            {
                base.Log.LogError(string.Format("Could not load the assembly. Bad assembly file?", new object[0]), new object[0]);
                return false;
            }
            foreach (string str in manifestResourceNames)
            {
                if (this.ResourceNameRegex.IsMatch(str))
                {
                    this.SaveResourceFile(str, this.OutputFolder, this.StripPrefix, assembly);
                }
            }
            if (base.Log.HasLoggedErrors)
            {
                return false;
            }
            return true;
        }

        private string GetRelativeTargetFilePath(string resourceName, string previxToRemove)
        {
            string path = resourceName;
            if (path.StartsWith(previxToRemove))
            {
                path = path.Remove(0, previxToRemove.Length);
            }
            string extension = Path.GetExtension(path);
            string resourceNameWithoutExtension = path.Remove(path.Length - extension.Length);
            return (this.ConvertResourceNameWithoutExtensionToRelativePath(resourceNameWithoutExtension) + extension);
        }

        private bool SaveResourceFile(string resourceName, string targetFolder, string previxToRemove, Assembly assembly)
        {
            string relativeTargetFilePath = this.GetRelativeTargetFilePath(resourceName, previxToRemove);
            string path = Path.Combine(targetFolder, relativeTargetFilePath);
            using (Stream stream = assembly.GetManifestResourceStream(resourceName))
            {
                byte[] buffer = new byte[stream.Length];
                stream.Read(buffer, 0, Convert.ToInt32(stream.Length));
                string directoryName = Path.GetDirectoryName(path);
                if (!Directory.Exists(directoryName))
                {
                    Directory.CreateDirectory(directoryName);
                }
                if (File.Exists(path))
                {
                    if (this.Overwrite)
                    {
                        File.Delete(path);
                    }
                    else
                    {
                        base.Log.LogError("Resource file already exists and no Overwrite property specified!", new object[0]);
                    }
                }
                using (FileStream stream2 = new FileStream(path, FileMode.CreateNew, FileAccess.Write, FileShare.None))
                {
                    stream2.Write(buffer, 0, Convert.ToInt32(stream.Length));
                }
            }
            return true;
        }

        [Required]
        public string AssemblyLoadPath
        {
            get
            {
                return this.assemblyLoadPath;
            }
            set
            {
                this.assemblyLoadPath = value;
            }
        }

        [Required]
        public string OutputFolder
        {
            get
            {
                return this.outputFolder;
            }
            set
            {
                this.outputFolder = value;
            }
        }

        public bool Overwrite
        {
            get
            {
                return this.overwrite;
            }
            set
            {
                this.overwrite = value;
            }
        }

        [Required]
        public string ResourceNamePattern
        {
            get
            {
                return this.resourceNamePattern;
            }
            set
            {
                this.resourceNamePattern = value;
            }
        }

        private Regex ResourceNameRegex
        {
            get
            {
                if (this.resourceNameRegex == null)
                {
                    try
                    {
                        this.resourceNameRegex = new Regex(this.ResourceNamePattern, RegexOptions.Compiled);
                    }
                    catch (ArgumentException exception)
                    {
                        base.Log.LogError("Invalid ResourceNamePattern! Details: {0}\r\n\r\n{1}", new object[] { exception.Message, exception.StackTrace });
                    }
                }
                return this.resourceNameRegex;
            }
        }

        public string StripPrefix
        {
            get
            {
                return this.stripPrefix;
            }
            set
            {
                this.stripPrefix = value;
            }
        }
    }
}

