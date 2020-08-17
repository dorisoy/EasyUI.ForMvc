namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.IO;
    using System.Runtime.CompilerServices;
    using System.Text;
    using System.Text.RegularExpressions;
    /*
    //压缩
    <UsingTask TaskName="CompressorTask" AssemblyFile="Build\Yahoo.Yui.Compressor.MsBuildTask.dll" />
    //合并
    <UsingTask TaskName="MergeFiles" AssemblyFile="Build\EasyUI.MSBuildTasks.dll" />
    //替换
    <UsingTask TaskName="Replace" AssemblyFile="Build\EasyUI.MSBuildTasks.dll" />
    //获取版本
    <UsingTask TaskName="GetVersion" AssemblyFile="Build\GetVersion.dll" />
    */
    /// <summary>
    /// 替换文件任务
    /// </summary>
    public class Replace : Task
    {
        private System.Text.RegularExpressions.Regex regex;

        public Replace()
        {
            this.EncodingValue = System.Text.Encoding.Default;
        }

        public override bool Execute()
        {
            if (this.Files == null)
            {
                base.Log.LogError("No files specified", new object[0]);
                return false;
            }
            if (string.IsNullOrEmpty(this.Pattern))
            {
                base.Log.LogError("Pattern not specified", new object[0]);
                return false;
            }
            if (this.Regex == null)
            {
                return false;
            }
            if (!string.IsNullOrEmpty(this.Encoding))
            {
                this.EncodingValue = System.Text.Encoding.GetEncoding(this.Encoding);
            }
            foreach (string str in this.Files)
            {
                this.ReplaceFile(str);
            }
            return !base.Log.HasLoggedErrors;
        }
        /// <summary>
        /// 读取并写入内容
        /// </summary>
        /// <param name="filePath"></param>
        private void ReadAndWriteContent(string filePath)
        {
            System.Text.Encoding encoding1 = System.Text.Encoding.UTF8;
            string input = File.ReadAllText(filePath);
            string str2 = this.Regex.Replace(input, this.Replacement ?? string.Empty);
            using (StreamWriter writer = new StreamWriter(filePath, false, this.EncodingValue))
            {
                writer.Write(str2);
            }
        }
        /// <summary>
        /// 替换文件
        /// </summary>
        /// <param name="filePath"></param>
        private void ReplaceFile(string filePath)
        {
            if (!File.Exists(filePath))
            {
                base.Log.LogError("File {0} not found!", new object[] { filePath });
            }
            FileAttributes fileAttributes = File.GetAttributes(filePath);
            File.SetAttributes(filePath, FileAttributes.Normal);
            this.ReadAndWriteContent(filePath);
            File.SetAttributes(filePath, fileAttributes);
        }
        /// <summary>
        /// 指定写入流编码格式：默认为ANSI
        /// </summary>
        public string Encoding { get; set; }

        private System.Text.Encoding EncodingValue { get; set; }

        [Required]
        public string[] Files { get; set; }

        public bool Multiline { get; set; }

        [Required]
        public string Pattern { get; set; }

        private System.Text.RegularExpressions.Regex Regex
        {
            get
            {
                if (this.regex == null)
                {
                    try
                    {
                        RegexOptions compiled = RegexOptions.Compiled;
                        if (this.Multiline)
                        {
                            compiled |= RegexOptions.Singleline | RegexOptions.Multiline;
                        }
                        this.regex = new System.Text.RegularExpressions.Regex(this.Pattern, compiled);
                    }
                    catch (ArgumentException exception)
                    {
                        base.Log.LogError("Invalid regular expression pattern! Details: {0}\r\n\r\n{1}", new object[] { exception.Message, exception.StackTrace });
                    }
                }
                return this.regex;
            }
        }

        public string Replacement { get; set; }
    }
}

