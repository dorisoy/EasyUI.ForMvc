namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.Runtime.CompilerServices;

    public class GetRelativeDate : Task
    {
        public GetRelativeDate()
        {
            this.Date = DateTime.Now;
            this.DeltaDays = 0;
            this.DeltaMonths = 0;
            this.DeltaYears = 0;
        }

        public override bool Execute()
        {
            DateTime date = this.Date;
            if (this.DeltaDays != 0)
            {
                date = date.AddDays((double) this.DeltaDays);
            }
            if (this.DeltaMonths != 0)
            {
                date = date.AddMonths(this.DeltaMonths);
            }
            if (this.DeltaYears != 0)
            {
                date = date.AddYears(this.DeltaYears);
            }
            this.Result = date;
            return true;
        }

        public DateTime Date { get; set; }

        public int DeltaDays { get; set; }

        public int DeltaMonths { get; set; }

        public int DeltaYears { get; set; }

        [Output]
        public DateTime Result { get; private set; }
    }
}

