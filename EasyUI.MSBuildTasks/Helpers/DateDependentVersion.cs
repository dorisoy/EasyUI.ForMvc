namespace EasyUI.MSBuildTasks.Helpers
{
    using System;

    internal class DateDependentVersion
    {
        private Version baseVersion;
        private DateTime currentDate;
        private Version newVersion;

        public DateDependentVersion(string baseVersion) : this(baseVersion, DateTime.Now)
        {
        }

        public DateDependentVersion(Version baseVersion) : this(baseVersion, DateTime.Now)
        {
        }

        public DateDependentVersion(string baseVersion, DateTime currentDate) : this(new Version(baseVersion), currentDate)
        {
        }

        public DateDependentVersion(Version baseVersion, DateTime currentDate)
        {
            this.baseVersion = baseVersion;
            this.currentDate = currentDate;
        }

        private Version GetNewVersion()
        {
            int major = this.baseVersion.Major;
            int month = this.CurrentDate.Month;
            if (this.CurrentDate.Year > major)
            {
                month += (this.CurrentDate.Year - major) * 12;
            }
            return new Version(major, this.baseVersion.Minor, month, this.CurrentDate.Day);
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

