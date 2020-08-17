namespace EasyUI.MSBuildTasks.WebUITestStudio
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.Runtime.InteropServices;
    using EasyUI.MSBuildTasks.Helpers;

    public class GetInstallerFileVersionByBase : Task
    {
        private DateTime now = DateTime.MinValue;
        private ITaskItem separator;
        private ITaskItem suffix;
        private ITaskItem versionBase;

        public override bool Execute()
        {
            int num;
            int num2;
            string[] strArray = this.VersionBase.ItemSpec.Split(new char[] { '.' });
            if (strArray.Length < 2)
            {
                base.Log.LogError("Incorrect BaseVersion. Should consist of at least two numbers, separated by a dot.", new object[0]);
                return false;
            }
            this.TryGetValidNumber(strArray[0], "Base Version First part", out num);
            this.TryGetValidNumber(strArray[1], "Base Version Second part", out num2);
            System.Version baseVersion = new System.Version(num, num2);
            DateAndFrameworkDependentVersion version2 = new DateAndFrameworkDependentVersion(baseVersion, this.Now, 0);
            string itemSpec = VersionFormatter.ForFile(version2.NewVersion);
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

        [Output]
        public ITaskItem Version
        {
            get
            {
                return this.suffix;
            }
        }

        [Required]
        public ITaskItem VersionBase
        {
            get
            {
                return this.versionBase;
            }
            set
            {
                this.versionBase = value;
            }
        }
    }
}

