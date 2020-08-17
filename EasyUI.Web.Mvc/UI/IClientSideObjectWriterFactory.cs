


namespace EasyUI.Web.Mvc.UI
{
    using System.IO;

    /// <summary>
    /// 创建自定义工厂 <see cref="IClientSideObjectWriter"/>.
    /// </summary>
    public interface IClientSideObjectWriterFactory
    {
        /// <summary>
        /// 创建写入者
        /// </summary>
        /// <param name="id">id标识</param>
        /// <param name="type"> type类型</param>
        /// <param name="textWriter">写入文本</param>
        /// <returns></returns>
        IClientSideObjectWriter Create(string id, string type, TextWriter textWriter);
    }
}