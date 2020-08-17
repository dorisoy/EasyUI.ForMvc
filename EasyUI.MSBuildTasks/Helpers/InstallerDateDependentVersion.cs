namespace EasyUI.MSBuildTasks.Helpers
{
    using System;

    internal class InstallerDateDependentVersion
    {
        private Version baseVersion;
        private DateTime currentDate;
        private Version newVersion;

        public InstallerDateDependentVersion(string baseVersion) : this(baseVersion, DateTime.Now)
        {
        }

        public InstallerDateDependentVersion(Version baseVersion) : this(baseVersion, DateTime.Now)
        {
        }

        public InstallerDateDependentVersion(string baseVersion, DateTime currentDate) : this(new Version(baseVersion), currentDate)
        {
        }

        public InstallerDateDependentVersion(Version baseVersion, DateTime currentDate)
        {
            this.baseVersion = baseVersion;
            this.currentDate = currentDate;
        }

        private Version GetNewVersion()
        {
            int major = this.baseVersion.Major;
            int num2 = major % 0x3e8;
            num2 *= 10;
            int num3 = num2 + this.baseVersion.Minor;
            int month = this.CurrentDate.Month;
            if (this.CurrentDate.Year > major)
            {
                month += (this.CurrentDate.Year - major) * 12;
            }
            return new Version(num3, month, this.CurrentDate.Day, 0);
        }

        public Version BaseVersion
        {
            get
            {
                return this.baseVersion;
            }
        }

        public DateTime CurrentDate
        {
            get
            {
                return this.currentDate;
            }
        }

        public Version NewVersion
        {
            get
            {
                if (this.newVersion == null)
                {
                    this.newVersion = this.GetNewVersion();
                }
                return this.newVersion;
            }
        }
    }
}

