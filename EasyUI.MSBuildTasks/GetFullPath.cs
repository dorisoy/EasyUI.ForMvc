namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.IO;
    using System.Runtime.CompilerServices;

    public class GetFullPath : Task
    {
        public override bool Execute()
        {
            this.FullPath = System.IO.Path.GetFullPath(this.Path);
            return true;
        }

        [Output]
        public string FullPath { get; private set; }

        [Required]
        public string Path { get; set; }
    }
}

