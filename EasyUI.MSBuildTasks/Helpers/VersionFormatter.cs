namespace EasyUI.MSBuildTasks.Helpers
{
    using System;

    internal class VersionFormatter
    {
        public static string ForFile(Version version)
        {
            return version.ToString(3);
        }

        public static string ForFile(Version version, string separator)
        {
            return ForFile(version).Replace(".", separator);
        }

        public static string Full(Version version, string separator)
        {
            return version.ToString().Replace(".", separator);
        }
    }
}

