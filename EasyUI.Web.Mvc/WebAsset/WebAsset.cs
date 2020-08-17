namespace EasyUI.Web.Mvc
{
    using System.IO;

    /// <summary>
    /// 表示Web资源
    /// </summary>
    public class WebAsset : IWebAsset
    {
        /// <summary>
        /// 表示Web资源
        /// </summary>
        /// <param name="source"></param>
        public WebAsset(string source)
        {
            Source = source;
        }
        /// <summary>
        /// 是否使用传送内容到网络
        /// </summary>
        public bool UseEasyUIContentDeliveryNetwork
        {
            get;
            set;
        }
        /// <summary>
        /// 获取文件名
        /// </summary>
        public string FileName
        {
            get
            {
                return Path.GetFileName(Source);
            }
        }
        /// <summary>
        /// 版本
        /// </summary>
        public string Version
        {
            get;
            set;
        }
        /// <summary>
        /// 资源
        /// </summary>
        public string Source
        {
            get;
            private set;
        }
        /// <summary>
        /// 扩展名
        /// </summary>
        public string Extension
        {
            get
            {
                return Path.GetExtension(Source);
            }
        }
    }
}