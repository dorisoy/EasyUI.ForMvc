




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    /// <summary>
    /// �ṩ�������ڵ�
    /// </summary>
    public interface IFilterNode
    {
        /// <summary>
        /// ���ܷ�����
        /// </summary>
        /// <param name="visitor"></param>
        void Accept(IFilterNodeVisitor visitor);
    }
}
