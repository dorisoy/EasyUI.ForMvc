namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using Microsoft.Win32;
    using System;
    using System.Runtime.CompilerServices;
    using EasyUI.MSBuildTasks.Helpers;

    public class AddRegValue : Task
    {
        public override bool Execute()
        {
            RegistryKey root = RegistryHelper.GetRoot(this.Root);
            if (root == null)
            {
                base.Log.LogError("Invalid Root specified. Expected: {0}", new object[] { "HKLM, HKCU, HKCR, HKCC" });
                return false;
            }
            try
            {
                root = root.OpenSubKey(this.ParentKeyPath, true);
            }
            catch (Exception)
            {
                base.Log.LogError("Invalid ParentKeyPath", new object[0]);
                return false;
            }
            RegistryValueKind valueKind = RegistryHelper.GetKind(this.ValueType);
            if (valueKind == RegistryValueKind.Unknown)
            {
                base.Log.LogError("Invalid ValueType. Expected: {0}", new object[] { "S(tring), B(inary), DW(ord), QW(ord), MS(MultiString), QW(ord)" });
                return false;
            }
            root.SetValue(this.ValueName, this.ValueValue, valueKind);
            root.Close();
            return true;
        }

        [Required]
        public string ParentKeyPath { get; set; }

        [Required]
        public string Root { get; set; }

        public string ValueName { get; set; }

        [Required]
        public string ValueType { get; set; }

        [Required]
        public string ValueValue { get; set; }
    }
}

