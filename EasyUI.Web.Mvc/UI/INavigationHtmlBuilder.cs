﻿




namespace EasyUI.Web.Mvc.UI
{
    using Infrastructure;

    public interface INavigationHtmlBuilder<TComponent, TItem>
        where TComponent : ViewComponentBase, INavigationItemContainer<TItem>
        where TItem:NavigationItem<TItem>
    {
        TComponent Component
        {
            get;
        }

        IActionMethodCache ActionMethodCache
        {
            get;
        }
    }
}
