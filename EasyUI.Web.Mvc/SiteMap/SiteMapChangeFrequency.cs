




namespace EasyUI.Web.Mvc
{
    using System;

    /// <summary>
    /// 站点地图的变化频率
    /// </summary>
    [Serializable]
    public enum SiteMapChangeFrequency
    {
        /// <summary>
        /// 自动更新
        /// </summary>
        Automatic = 0,
        /// <summary>
        /// 每日
        /// </summary>
        Daily = 1,
        /// <summary>
        /// 总是
        /// </summary>
        Always = 2,
        /// <summary>
        /// 每小时
        /// </summary>
        Hourly = 3,
        /// <summary>
        /// 每周
        /// </summary>
        Weekly = 4,
        /// <summary>
        /// 每月
        /// </summary>
        Monthly = 5,
        /// <summary>
        /// 每年
        /// </summary>
        Yearly = 6,
        /// <summary>
        /// 从不更改
        /// </summary>
        Never = 7
    }
}