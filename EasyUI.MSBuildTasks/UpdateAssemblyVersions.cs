namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.IO;
    using System.Runtime.CompilerServices;
    using System.Text.RegularExpressions;
    using EasyUI.MSBuildTasks.Helpers;

    public class UpdateAssemblyVersions : Task
    {
        private DateTime now = DateTime.MinValue;

        private void ApplyNewDesignerInfoVersion(Version newVersion, string fullDesignerInfoFilePath)
        {
            Func<string, string> replacer = delegate (string oldContent) {
                Regex regex = new Regex(@"(EasyUI\.Web\.Design, Version)=\d{4}\.\d{1,2}\.\d{3,4}\.\d+(, Culture=neutral)", RegexOptions.Compiled);
                string replacement = string.Format("$1={0}$2", newVersion.ToString());
                return regex.Replace(oldContent, replacement);
            };
            this.ApplyNewVersionToFile(newVersion, fullDesignerInfoFilePath, replacer);
        }

        private void ApplyNewVersion(Version newVersion)
        {
            foreach (string str in this.TargetFiles)
            {
                string fullTargetFilePath = this.TryGetFullFilePath(str);
                if (!base.Log.HasLoggedErrors)
                {
                    this.ApplyNewVersionToFile(newVersion, fullTargetFilePath);
                }
            }
            if (this.DesignerInfoFile != null)
            {
                string fullDesignerInfoFilePath = this.TryGetFullFilePath(this.DesignerInfoFile);
                this.ApplyNewDesignerInfoVersion(newVersion, fullDesignerInfoFilePath);
            }
        }

        private void ApplyNewVersionToFile(Version newVersion, string fullTargetFilePath)
        {
            Func<string, string> replacer = delegate (string oldContent) {
                Regex regex = new Regex("(?<Start>\\[assembly: Assembly(File)?Version\\(\")\\d{4}\\.\\d{1,2}\\.\\d{3,4}\\.\\d+(\"\\)\\])", RegexOptions.Compiled);
                string replacement = string.Format("${{Start}}{0}$2", newVersion.ToString());
                return regex.Replace(oldContent, replacement);
            };
            this.ApplyNewVersionToFile(newVersion, fullTargetFilePath, replacer);
        }

        private void ApplyNewVersionToFile(Version newVersion, string fullTargetFilePath, Func<string, string> replacer)
        {
            FileAttributes fileAttributes = File.GetAttributes(fullTargetFilePath);
            File.SetAttributes(fullTargetFilePath, FileAttributes.Normal);
            string str = File.ReadAllText(fullTargetFilePath);
            string contents = replacer(str);
            File.WriteAllText(fullTargetFilePath, contents);
            File.SetAttributes(fullTargetFilePath, fileAttributes);
        }

        private bool CheckFrameworkVersion(int framework)
        {
            if ((framework != 20) && (framework != 0x23))
            {
                return (framework == 40);
            }
            return true;
        }

        public override bool Execute()
        {
            Version updatedVersion;
            string assemblyInfoPath = this.TryGetFullFilePath(this.SourceAssemblyInfo);
            if (base.Log.HasLoggedErrors)
            {
                return false;
            }
            if (!this.CheckFrameworkVersion(this.Framework))
            {
                base.Log.LogError("Invalid Framework version. Expected: 20, 35, 40.", new object[0]);
                return false;
            }
            try
            {
                AssemblyInfoParser parser = new AssemblyInfoParser(assemblyInfoPath);
                updatedVersion = parser.AssemblyVersion;
            }
            catch (ArgumentException exception)
            {
                base.Log.LogError(exception.Message, new object[0]);
                return false;
            }
            int num = this.Now.Year - 1;
            int year = this.Now.Year;
            if ((updatedVersion.Major < num) && (updatedVersion.Major > year))
            {
                base.Log.LogError("Invalid year in assembly version.", new object[0]);
            }
            if (base.Log.HasLoggedErrors)
            {
                return false;
            }
            updatedVersion = this.GetUpdatedVersion(updatedVersion);
            this.ApplyNewVersion(updatedVersion);
            return true;
        }

        private Version GetUpdatedVersion(Version baseVersion)
        {
            int major = baseVersion.Major;
            int month = this.Now.Month;
            if (this.Now.Year > major)
            {
                month += 12;
            }
            int day = this.Now.Day;
            month *= 100;
            return new Version(major, baseVersion.Minor, month + day, this.Framework);
        }

        private string TryGetFullFilePath(string filePath)
        {
            string fullPath = null;
            try
            {
                fullPath = Path.GetFullPath(filePath);
            }
            catch (ArgumentException)
            {
                base.Log.LogError("Invalid file path \"{0}\".", new object[] { filePath });
                return null;
            }
            catch (NotSupportedException)
            {
                base.Log.LogError("Invalid file path (colon not allowed) \"{0}\".", new object[] { filePath });
                return null;
            }
            catch (PathTooLongException)
            {
                base.Log.LogError("Path \"{0}\" too long ", new object[] { filePath });
                return null;
            }
            if (!File.Exists(filePath))
            {
                base.Log.LogError("Invalid file path. File \"{0}\" (resolved to \"{1}\") was not found.", new object[] { filePath, fullPath });
                return null;
            }
            return fullPath;
        }

        public string DesignerInfoFile { get; set; }

        [Required]
        public int Framework { get; set; }

        internal DateTime Now
        {
            get
            {
                if (this.now == DateTime.MinValue)
                {
                    this.now = DateTime.Now;
                }
                return this.now;
            }
            set
            {
                this.now = value;
            }
        }

        [Required]
        public string SourceAssemblyInfo { get; set; }

        [Required]
        public string[] TargetFiles { get; set; }
    }
}

