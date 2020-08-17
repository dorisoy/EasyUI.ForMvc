namespace EasyUI.MSBuildTasks.Web
{
    using System;
    using System.Text.RegularExpressions;

    /// <summary>
    /// 提取CSS资源
    /// </summary>
    public class ExtractCssResources : ExtractResources
    {
        private Regex skinSpecificControlCssFileDetector = new Regex(@"([^\.]*?)\.([^\.]*?)\.\1", RegexOptions.Compiled);

        protected override string ConvertResourceNameWithoutExtensionToRelativePath(string resourceNameWithoutExtension)
        {
            if (!this.skinSpecificControlCssFileDetector.IsMatch(resourceNameWithoutExtension))
            {
                return base.ConvertResourceNameWithoutExtensionToRelativePath(resourceNameWithoutExtension);
            }
            string str = this.skinSpecificControlCssFileDetector.Replace(resourceNameWithoutExtension, "$1.$2|$1");
            return base.ConvertResourceNameWithoutExtensionToRelativePath(str).Replace("|", ".");
        }
    }
}

