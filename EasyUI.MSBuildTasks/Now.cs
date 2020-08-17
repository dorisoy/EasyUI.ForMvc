namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.Runtime.CompilerServices;

    public class Now : Task
    {
        public override bool Execute()
        {
            this.Value = DateTime.Now;
            return true;
        }

        [Output]
        public DateTime Value { get; private set; }
    }
}

