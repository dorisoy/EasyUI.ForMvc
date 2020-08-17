




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{

    /// <summary>
    /// Âß¼­Óë
    /// </summary>
    public class AndNode : IFilterNode, ILogicalNode
    {
        public IFilterNode First 
        { 
            get; 
            set; 
        }

        public IFilterNode Second 
        { 
            get; 
            set; 
        }
		
        public FilterCompositionLogicalOperator LogicalOperator
		{
			get
			{
                return FilterCompositionLogicalOperator.And;
			}
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
