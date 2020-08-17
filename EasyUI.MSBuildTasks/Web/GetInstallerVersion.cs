namespace EasyUI.MSBuildTasks.Web
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.Runtime.CompilerServices;

    /// <summary>
    /// 获取安装版本
    /// </summary>
    public class GetInstallerVersion : Task
    {
        private string version;

        public GetInstallerVersion()
        {
            this.Now = DateTime.Now;
        }

        public override bool Execute()
        {
            int num = (int) Math.Floor((double) (((double) this.Now.Year) / 1000.0));
            int num2 = this.Now.Year - (num * 0x3e8);
            int major = new System.Version(string.Format(this.VersionFormatString, 0, 0)).Major;
            int month = this.Now.Month;
            if (num2 > major)
            {
                month += (num2 - major) * 12;
            }
            this.version = string.Format(this.VersionFormatString, month, this.Now.Day);
            return true;
        }

        public DateTime Now { get; set; }

        [Output]
        public string Version
        {
            get
            {
                return this.version;
            }
        }

        [Required]
        public string VersionFormatString { get; set; }
    }
}

