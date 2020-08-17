// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System;

    public interface IInputComponent<T> : IViewComponent where T : struct
    {
        Nullable<T> Value { get; set; }
    }
}
