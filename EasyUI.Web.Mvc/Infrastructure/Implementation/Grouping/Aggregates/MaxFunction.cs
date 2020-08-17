




namespace EasyUI.Web.Mvc
{
    /// <summary>
    /// Represents a function that returns the greatest item from a set of items.
    /// </summary>
    public class MaxFunction : EnumerableSelectorAggregateFunction
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="MaxFunction"/> class.
        /// </summary>
        public MaxFunction()
        {
        }

        /// <summary>
        /// Gets the the Max method name.
        /// </summary>
        /// <value><c>Max</c>.</value>
        public override string AggregateMethodName
        {
            get
            {
                return "Max";
            }
        }
    }
}