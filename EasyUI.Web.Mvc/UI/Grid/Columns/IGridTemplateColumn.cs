



namespace EasyUI.Web.Mvc.UI
{
    using System;

    public interface IGridTemplateColumn<T> : IGridColumn
        where T : class
    {
        Action<T> Template
        {
            get;
            set;
        }
    }
}
