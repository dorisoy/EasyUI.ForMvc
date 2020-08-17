namespace EasyUI.MSBuildTasks.Helpers
{
    using Microsoft.Win32;
    using System;

    internal class RegistryHelper
    {
        public const string ExpectedKindKeys = "S(tring), B(inary), DW(ord), QW(ord), MS(MultiString), QW(ord)";
        public const string ExpectedRootKeys = "HKLM, HKCU, HKCR, HKCC";

        public static RegistryValueKind GetKind(string KindKey)
        {
            switch (KindKey)
            {
                case "B":
                    return RegistryValueKind.Binary;

                case "DW":
                    return RegistryValueKind.DWord;

                case "ES":
                    return RegistryValueKind.ExpandString;

                case "MS":
                    return RegistryValueKind.MultiString;

                case "QW":
                    return RegistryValueKind.QWord;

                case "S":
                    return RegistryValueKind.String;
            }
            return RegistryValueKind.Unknown;
        }

        public static RegistryKey GetRoot(string RootKey)
        {
            RegistryKey key = null;
            string str = RootKey;
            if (str == null)
            {
                return key;
            }
            if (!(str == "HKLM"))
            {
                if (str != "HKCU")
                {
                    if (str == "HKCR")
                    {
                        return Registry.ClassesRoot;
                    }
                    if (str != "HKCC")
                    {
                        return key;
                    }
                    return Registry.CurrentConfig;
                }
            }
            else
            {
                return Registry.LocalMachine;
            }
            return Registry.CurrentUser;
        }
    }
}

