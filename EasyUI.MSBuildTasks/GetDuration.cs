namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.Runtime.CompilerServices;

    public class GetDuration : Task
    {
        public int duration;

        public override bool Execute()
        {
            this.duration = Convert.ToInt32(this.End.Subtract(this.Start).TotalSeconds);
            return true;
        }

        [Output]
        public int Duration
        {
            get
            {
                return this.duration;
            }
        }

        [Required]
        public DateTime End { get; set; }

        [Required]
        public DateTime Start { get; set; }
    }
}

