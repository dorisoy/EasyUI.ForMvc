




namespace EasyUI.Web.Mvc
{
    /// <summary>
    /// Represents a function that returns the sum of all items from a set of items.
    /// </summary>
    public class SumFunction : EnumerableSelectorAggregateFunction
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="SumFunction"/> class.
        /// </summary>
        public SumFunction()
        {
        }

        /// <summary>
        /// Gets the the Min method name.
        /// </summary>
        /// <value><c>Min</c>.</value>
        public override string AggregateMethodName
        {
            get
            {
                return "Sum";
            }
        }
    }
}