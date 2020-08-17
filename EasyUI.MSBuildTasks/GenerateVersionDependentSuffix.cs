namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.Runtime.InteropServices;
    using EasyUI.MSBuildTasks.Helpers;

    public class GenerateVersionDependentSuffix : Task
    {
        private DateTime now = DateTime.MinValue;
        private ITaskItem releaseQ;
        private ITaskItem releaseYear;
        private ITaskItem separator;
        private ITaskItem suffix;

        public override bool Execute()
        {
            int num;
            int num2;
            this.TryGetValidNumber(this.ReleaseYear.ItemSpec, "ReleaseYear", out num);
            this.TryGetValidNumber(this.ReleaseQ.ItemSpec, "ReleaseQ", out num2);
            Version baseVersion = new Version(num, num2);
            DateAndFrameworkDependentVersion version2 = new DateAndFrameworkDependentVersion(baseVersion, this.Now, 20);
            string separator = (this.separator != null) ? this.separator.ItemSpec : "_";
            string itemSpec = VersionFormatter.ForFile(version2.NewVersion, separator);
            this.suffix = new TaskItem(itemSpec);
            return !base.Log.HasLoggedErrors;
        }

        private void TryGetValidNumber(string input, string inputTitle, out int number)
        {
            new NumberParser().TryGetValidNumber(input, inputTitle, base.Log, out number);
        }

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
        public ITaskItem ReleaseQ
        {
            get
            {
                return this.releaseQ;
            }
            set
            {
                this.releaseQ = value;
            }
        }

        [Required]
        public ITaskItem ReleaseYear
        {
            get
            {
                return this.releaseYear;
            }
            set
            {
                this.releaseYear = value;
            }
        }

        public ITaskItem Separator
        {
            get
            {
                return this.separator;
            }
            set
            {
                this.separator = value;
            }
        }

        [Output]
        public ITaskItem Suffix
        {
            get
            {
                return this.suffix;
            }
        }
    }
}

