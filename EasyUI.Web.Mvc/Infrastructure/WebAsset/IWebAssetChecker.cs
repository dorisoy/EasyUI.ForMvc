namespace EasyUI.Web.Mvc.Infrastructure
{
    /// <summary>
    /// 提供Web资源检查器
    /// </summary>
    public interface IWebAssetChecker
    {
        bool IsNative(WebAsset asset);
        bool IsAbsolute(WebAsset asset);
    }
}
