




namespace EasyUI.Web.Mvc
{
    /// <summary>
    /// 表示返回一组参数的算术平均值的函数
    /// </summary>
    public class AverageFunction : EnumerableSelectorAggregateFunction
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AverageFunction"/> class.
        /// </summary>
        public AverageFunction()
        {
        }

        /// <summary>
        /// Gets the the Average method name.
        /// </summary>
        /// <value><c>Average</c>.</value>
        public override string AggregateMethodName
        {
            get
            {
                return "Average";
            }
        }
    }
}