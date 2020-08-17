




namespace EasyUI.Web.Mvc
{
    using System;

    /// <summary>
    /// վ���ͼ�ı仯Ƶ��
    /// </summary>
    [Serializable]
    public enum SiteMapChangeFrequency
    {
        /// <summary>
        /// �Զ�����
        /// </summary>
        Automatic = 0,
        /// <summary>
        /// ÿ��
        /// </summary>
        Daily = 1,
        /// <summary>
        /// ����
        /// </summary>
        Always = 2,
        /// <summary>
        /// ÿСʱ
        /// </summary>
        Hourly = 3,
        /// <summary>
        /// ÿ��
        /// </summary>
        Weekly = 4,
        /// <summary>
        /// ÿ��
        /// </summary>
        Monthly = 5,
        /// <summary>
        /// ÿ��
        /// </summary>
        Yearly = 6,
        /// <summary>
        /// �Ӳ�����
        /// </summary>
        Never = 7
    }
}