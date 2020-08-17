namespace EasyUI.Web.Mvc.Infrastructure
{

    /// <summary>
    /// 解析上下文
    /// </summary>
    public class ResolverContext
    {
        public bool SupportsCompression
        {
            get;
            set;
        }

        public bool IsSecureConnection
        {
            get;
            set;
        }

        public string HttpHandlerPath
        {
            get;
            set;
        }

        public string ContentType
        {
            get;
            set;
        }
    }
}
