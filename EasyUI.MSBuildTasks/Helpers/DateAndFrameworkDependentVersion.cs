namespace EasyUI.MSBuildTasks.Helpers
{
    using System;

    internal class DateAndFrameworkDependentVersion
    {
        private Version baseVersion;
        private DateTime currentDate;
        private int frameworkVersion;
        private Version newVersion;

        public DateAndFrameworkDependentVersion(string baseVersion, int frameworkVersion) : this(baseVersion, DateTime.Now, frameworkVersion)
        {
        }

        public DateAndFrameworkDependentVersion(Version baseVersion, int frameworkVersion) : this(baseVersion, DateTime.Now, frameworkVersion)
        {
        }

        public DateAndFrameworkDependentVersion(string baseVersion, DateTime currentDate, int frameworkVersion) : this(new Version(baseVersion), currentDate, frameworkVersion)
        {
        }

        public DateAndFrameworkDependentVersion(Version baseVersion, DateTime currentDate, int frameworkVersion)
        {
            this.baseVersion = baseVersion;
            this.currentDate = currentDate;
            this.frameworkVersion = frameworkVersion;
        }

        private Version GetNewVersion()
        {
            int major = this.baseVersion.Major;
            int month = this.CurrentDate.Month;
            if (this.CurrentDate.Year > major)
            {
                month += (this.CurrentDate.Year - major) * 12;
            }
            int day = this.CurrentDate.Day;
            month *= 100;
            return new Version(major, this.baseVersion.Minor, month + day, this.frameworkVersion);
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

