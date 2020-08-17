namespace EasyUI.MSBuildTasks.Helpers
{
    using System;
    using System.IO;
    using System.Text.RegularExpressions;

    /// <summary>
    /// 程序集解析器
    /// </summary>
    internal class AssemblyInfoParser
    {
        private string assemblyInfoPath;
        private Version assemblyVersion;
        private bool parsed;

        public AssemblyInfoParser(string assemblyInfoPath)
        {
            this.assemblyInfoPath = assemblyInfoPath;
        }

        private void EnsureParsed()
        {
            if (!this.parsed)
            {
                string content = File.ReadAllText(this.assemblyInfoPath);
                this.Parse(content);
            }
        }

        private void Parse(string content)
        {
            Regex regex = new Regex("\\[assembly: AssemblyVersion\\(\"(\\d{4}\\.\\d{1,2}\\.\\d{3,4}\\.\\d+)\"\\)\\]", RegexOptions.Compiled);
            string str = regex.Match(content).Groups[1].Value;
            if (string.IsNullOrEmpty(str))
            {
                throw new ArgumentException("No matching AssemblyVersion Attribute found in source AssemblyInfo file! Searching for xxxx.x.xxx[x].0 (x -> digit, [] -> optional.");
            }
            Version version = new Version(str);
            this.assemblyVersion = version;
        }

        public Version AssemblyVersion
        {
            get
            {
                this.EnsureParsed();
                return this.assemblyVersion;
            }
        }
    }
}

