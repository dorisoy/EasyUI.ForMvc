// (c) Copyright 2002-2009 EasyUI 



using System;
using System.Web.Mvc;

namespace EasyUI.Web.Mvc.UI
{
    public static class InputComponentExtensions
    {
        public static T? GetValue<T>(this IInputComponent<T> instance, Func<object, T?> converter) where T : struct
        {
            T? value = null;
            ModelState state;
            ViewDataDictionary viewData = instance.ViewContext.ViewData;

            object valueFromViewData = viewData.Eval(instance.Name);

            if (viewData.ModelState.TryGetValue(instance.Name, out state) && (state.Value != null))
            {
                if (viewData.ModelState.IsValidField(instance.Name))
                {
                    try
                    {
                        value = state.Value.ConvertTo(typeof(T), state.Value.Culture) as T?;
                    }
                    catch (InvalidOperationException) { }
                }
            }
            else if (instance.Value != null)
            {
                value = instance.Value;
            }
            else if (valueFromViewData != null)
            {
                value = converter(valueFromViewData);
            }

            instance.Value = value;

            return value;
        }

        public static string GetAttemptedValue<T>(this IInputComponent<T> instance) where T: struct
        {
            ModelState state;
            if (instance.ViewContext.ViewData.ModelState.TryGetValue(instance.Name, out state) && state.Value != null) 
            {
                return state.Value.AttemptedValue;
            }

            return string.Empty;
        }
    }
}