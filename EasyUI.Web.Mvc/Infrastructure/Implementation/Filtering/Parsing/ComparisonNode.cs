




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{

    /// <summary>
    /// ±È½Ï
    /// </summary>
    public class ComparisonNode : IFilterNode, IOperatorNode
    {
        public FilterOperator FilterOperator 
        { 
            get; 
            set; 
        }

        public virtual IFilterNode First 
        { 
            get; 
            set; 
        }

        public virtual IFilterNode Second
        {
            get;
            set;
        }

        public void Accept(IFilterNodeVisitor visitor)
        {
            visitor.StartVisit(this);
            
            First.Accept(visitor);
            Second.Accept(visitor);

            visitor.EndVisit();
        }
    }
}
