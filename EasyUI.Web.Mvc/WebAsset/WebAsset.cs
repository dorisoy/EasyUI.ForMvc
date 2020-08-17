namespace EasyUI.Web.Mvc
{
    using System.IO;

    /// <summary>
    /// ��ʾWeb��Դ
    /// </summary>
    public class WebAsset : IWebAsset
    {
        /// <summary>
        /// ��ʾWeb��Դ
        /// </summary>
        /// <param name="source"></param>
        public WebAsset(string source)
        {
            Source = source;
        }
        /// <summary>
        /// �Ƿ�ʹ�ô������ݵ�����
        /// </summary>
        public bool UseEasyUIContentDeliveryNetwork
        {
            get;
            set;
        }
        /// <summary>
        /// ��ȡ�ļ���
        /// </summary>
        public string FileName
        {
            get
            {
                return Path.GetFileName(Source);
            }
        }
        /// <summary>
        /// �汾
        /// </summary>
        public string Version
        {
            get;
            set;
        }
        /// <summary>
        /// ��Դ
        /// </summary>
        public string Source
        {
            get;
            private set;
        }
        /// <summary>
        /// ��չ��
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