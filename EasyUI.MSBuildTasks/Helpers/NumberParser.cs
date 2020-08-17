namespace EasyUI.MSBuildTasks.Helpers
{
    using Microsoft.Build.Utilities;
    using System;
    using System.Runtime.InteropServices;

    internal class NumberParser
    {
        public void TryGetValidNumber(string input, string inputTitle, TaskLoggingHelper log, out int number)
        {
            int num;
            if (string.IsNullOrEmpty(input))
            {
                string format = string.Format("{0} not specified", inputTitle);
                log.LogError(string.Format(format, new object[0]), new object[0]);
                throw new ArgumentException(format);
            }
            if (!int.TryParse(input, out num))
            {
                string str2 = string.Format("{0} incorrect", inputTitle);
                log.LogError(string.Format(str2, new object[0]), new object[0]);
                throw new ArgumentException(str2);
            }
            number = num;
        }
    }
}

