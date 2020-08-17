





namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    /// <summary>
    /// ��������
    /// </summary>
    public class BooleanNode : IFilterNode, IValueNode
    {
        public object Value
        {
            get;
            set;
        }

        public void Accept(IFilterNodeVisitor visitor)
        {
            visitor.Visit(this);
        }
    }
}
