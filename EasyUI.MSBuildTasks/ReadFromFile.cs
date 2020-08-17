namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.IO;
    using System.Runtime.CompilerServices;
    using System.Text.RegularExpressions;

    public class ReadFromFile : Task
    {
        public ReadFromFile()
        {
            this.MatchId = 0;
            this.GroupId = -1;
        }

        public override bool Execute()
        {
            string fullPath = Path.GetFullPath(this.FilePath);
            if (!File.Exists(fullPath))
            {
                base.Log.LogError("The file specified by the path {0} does not exist!", new object[] { fullPath });
                return false;
            }
            string input = File.ReadAllText(this.FilePath);
            if (string.IsNullOrEmpty(this.Pattern))
            {
                this.Result = input;
                return true;
            }
            RegexOptions none = RegexOptions.None;
            if (this.Multiline)
            {
                none = RegexOptions.Multiline;
            }
            MatchCollection matchs = new Regex(this.Pattern, none).Matches(input);
            if (matchs.Count == 0)
            {
                base.Log.LogError("No Matches Found", new object[0]);
                return false;
            }
            if (matchs.Count <= this.MatchId)
            {
                base.Log.LogError("No such MatchId", new object[0]);
                return false;
            }
            Match match = matchs[this.MatchId];
            if (this.GroupId < 0)
            {
                this.Result = match.Value;
                return true;
            }
            if (match.Groups.Count <= this.GroupId)
            {
                base.Log.LogError("No such GroupId", new object[0]);
                return false;
            }
            this.Result = match.Groups[this.GroupId].Value;
            return true;
        }

        [Required]
        public string FilePath { get; set; }

        public int GroupId { get; set; }

        public int MatchId { get; set; }

        public bool Multiline { get; set; }

        public string Pattern { get; set; }

        [Output]
        public string Result { get; private set; }
    }
}

