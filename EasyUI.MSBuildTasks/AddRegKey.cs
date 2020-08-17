namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using Microsoft.Win32;
    using System;
    using System.Runtime.CompilerServices;
    using EasyUI.MSBuildTasks.Helpers;

    public class AddRegKey : Task
    {
        public override bool Execute()
        {
            string keyPath;
            RegistryKey root = RegistryHelper.GetRoot(this.Root);
            if (root == null)
            {
                base.Log.LogError("Invalid Root specified. Expected: {0}", new object[] { "HKLM, HKCU, HKCR, HKCC" });
                return false;
            }
            if (!string.IsNullOrEmpty(this.KeyPath))
            {
                keyPath = this.KeyPath;
            }
            else if (string.IsNullOrEmpty(this.ParentKeyPath))
            {
                keyPath = this.KeyName;
            }
            else
            {
                keyPath = this.ParentKeyPath + @"\" + this.KeyName;
            }
            root.CreateSubKey(keyPath).Close();
            return true;
        }

        public string KeyName { get; set; }

        public string KeyPath { get; set; }

        public string ParentKeyPath { get; set; }

        [Required]
        public string Root { get; set; }
    }
}

