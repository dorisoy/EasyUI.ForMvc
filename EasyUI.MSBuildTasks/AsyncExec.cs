namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Tasks;
    using System;
    using System.Collections;
    using System.Collections.Specialized;
    using System.Diagnostics;

    public class AsyncExec : Exec
    {
        protected override int ExecuteTool(string pathToTool, string responseFileCommands, string commandLineCommands)
        {
            new Process { StartInfo = this.GetProcessStartInfo(pathToTool, commandLineCommands) }.Start();
            return 0;
        }

        protected virtual ProcessStartInfo GetProcessStartInfo(string executable, string arguments)
        {
            if (arguments.Length > 0x7d00)
            {
                base.Log.LogWarningWithCodeFromResources("ToolTask.CommandTooLong", new object[] { base.GetType().Name });
            }
            ProcessStartInfo info = new ProcessStartInfo(executable, arguments) {
                WindowStyle = ProcessWindowStyle.Hidden,
                CreateNoWindow = true,
                UseShellExecute = true
            };
            string workingDirectory = this.GetWorkingDirectory();
            if (workingDirectory != null)
            {
                info.WorkingDirectory = workingDirectory;
            }
            StringDictionary environmentOverride = this.EnvironmentOverride;
            if (environmentOverride != null)
            {
                foreach (DictionaryEntry entry in environmentOverride)
                {
                    info.EnvironmentVariables.Remove(entry.Key.ToString());
                    string key = entry.Key.ToString();
                    info.EnvironmentVariables.Add(key, entry.Value.ToString());
                }
            }
            return info;
        }
    }
}

