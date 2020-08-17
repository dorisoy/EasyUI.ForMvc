namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.Globalization;
    using System.Runtime.CompilerServices;

    public class FormatDateTime : Task
    {
        private DateTime now = DateTime.MinValue;

        public override bool Execute()
        {
            this.Result = this.Now.ToString(this.FormatString, DateTimeFormatInfo.InvariantInfo);
            return true;
        }

        [Required]
        public string FormatString { get; set; }

        public DateTime Now
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
        public string Result { get; private set; }
    }
}

