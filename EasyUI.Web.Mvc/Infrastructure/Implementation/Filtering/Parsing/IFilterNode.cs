




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    /// <summary>
    /// 提供过滤器节点
    /// </summary>
    public interface IFilterNode
    {
        /// <summary>
        /// 接受访问器
        /// </summary>
        /// <param name="visitor"></param>
        void Accept(IFilterNodeVisitor visitor);
    }
}
