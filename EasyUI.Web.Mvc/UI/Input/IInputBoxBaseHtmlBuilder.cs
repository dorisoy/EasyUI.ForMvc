




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// 表示用于InputBox的Html生成器基类
    /// </summary>
    public interface IInputBoxBaseHtmlBuilder
    {
        /// <summary>
        /// 构建HTMLNode
        /// </summary>
        /// <param name="objectName"></param>
        /// <returns></returns>
        IHtmlNode Build(string objectName);
        /// <summary>
        /// Input 标签
        /// </summary>
        /// <returns></returns>
        IHtmlNode InputTag();
    }
}
