



namespace EasyUI.Web.Mvc
{
    /// <summary>
    /// 过滤器操作数 <see cref="FilterDescription"/>
    /// </summary>
    public enum FilterOperator
    {
        /// <summary>
        /// 小于
        /// </summary>
        IsLessThan,
        /// <summary>
        /// 小于等于
        /// </summary>
        IsLessThanOrEqualTo,
        /// <summary>
        /// 等于
        /// </summary>
        IsEqualTo,
        /// <summary>
        /// 不低于
        /// </summary>
        IsNotEqualTo,
        /// <summary>
        /// 大于等于
        /// </summary>
        IsGreaterThanOrEqualTo,
        /// <summary>
        /// 大于
        /// </summary>
        IsGreaterThan,
        /// <summary>
        /// 必须从右开始起
        /// </summary>
        StartsWith,
        /// <summary>
        /// 补习从左开始
        /// </summary>
        EndsWith,
        /// <summary>
        /// 必须包含
        /// </summary>
        Contains,
        /// <summary>
        /// 必须被包含
        /// </summary>
        IsContainedIn
    }
}