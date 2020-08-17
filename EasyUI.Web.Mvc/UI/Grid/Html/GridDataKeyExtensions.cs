﻿// (c) Copyright 2002-2009 EasyUI 





namespace EasyUI.Web.Mvc.UI.Html
{
    using System.Collections.Generic;
    using System.Web.Mvc;

    public static class GridDataKeyExtensions
    {
#if MVC1
        public static string GetCurrentValue(this IGridDataKey dataKey, IDictionary<string, ValueProviderResult> valueProvider)
        {
            ValueProviderResult value;

            valueProvider.TryGetValue(dataKey.RouteKey, out value);

            if (value != null)
            {
                return value.AttemptedValue;
            }

            return null;
        }
#else        
        public static string GetCurrentValue(this IGridDataKey dataKey, IValueProvider valueProvider)
        {
            var value = valueProvider.GetValue(dataKey.RouteKey);

            if (value != null)
            {
                return value.AttemptedValue;
            }

            return null;
        }
#endif
    }
}
