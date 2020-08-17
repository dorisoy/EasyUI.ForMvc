namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.IO;
    using System.Runtime.CompilerServices;

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
    /// 合并文件任务
    /// </summary>
    public class MergeFiles : Task
    {
        public override bool Execute()
        {
            using (MemoryStream stream = new MemoryStream())
            {
                using (MemoryStream stream2 = new MemoryStream())
                {
                    foreach (ITaskItem item in this.Targets)
                    {
                        byte[] buffer = File.ReadAllBytes(item.ItemSpec);
                        stream.Write(buffer, 0, buffer.Length);
                    }
                    if (File.Exists(this.Output.ItemSpec))
                    {
                        byte[] buffer2 = File.ReadAllBytes(this.Output.ItemSpec);
                        stream2.Write(buffer2, 0, buffer2.Length);
                    }
                    stream.Seek(0L, SeekOrigin.Begin);
                    stream2.Seek(0L, SeekOrigin.Begin);
                    if (!this.StreamCompare(stream, stream2))
                    {
                        base.Log.LogMessage(MessageImportance.Normal, "Merging {0}", new object[] { this.Output.ItemSpec });
                        this.SaveOutputFile(stream);
                    }
                }
            }
            return true;
        }

        private void SaveOutputFile(MemoryStream mergedContent)
        {
            string itemSpec = this.Output.ItemSpec;
            FileAttributes normal = FileAttributes.Normal;
            if (File.Exists(itemSpec))
            {
                normal = File.GetAttributes(itemSpec);
                File.SetAttributes(itemSpec, FileAttributes.Normal);
            }
            File.WriteAllBytes(itemSpec, mergedContent.ToArray());
            if (File.Exists(itemSpec))
            {
                File.SetAttributes(itemSpec, normal);
            }
        }

        private bool StreamCompare(Stream stream1, Stream stream2)
        {
            int num;
            int num2;
            if (stream1 == stream2)
            {
                return true;
            }
            if (stream1.Length != stream2.Length)
            {
                return false;
            }
            do
            {
                num = stream1.ReadByte();
                num2 = stream2.ReadByte();
            }
            while ((num == num2) && (num != -1));
            return ((num - num2) == 0);
        }

        [Output]
        public ITaskItem Output { get; set; }

        [Required]
        public ITaskItem[] Targets { get; set; }
    }
}

