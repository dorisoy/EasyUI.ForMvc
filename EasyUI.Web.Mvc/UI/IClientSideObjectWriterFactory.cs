


namespace EasyUI.Web.Mvc.UI
{
    using System.IO;

    /// <summary>
    /// �����Զ��幤�� <see cref="IClientSideObjectWriter"/>.
    /// </summary>
    public interface IClientSideObjectWriterFactory
    {
        /// <summary>
        /// ����д����
        /// </summary>
        /// <param name="id">id��ʶ</param>
        /// <param name="type"> type����</param>
        /// <param name="textWriter">д���ı�</param>
        /// <returns></returns>
        IClientSideObjectWriter Create(string id, string type, TextWriter textWriter);
    }
}