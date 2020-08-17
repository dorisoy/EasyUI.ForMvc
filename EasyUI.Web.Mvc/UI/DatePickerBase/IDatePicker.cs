﻿using System;
using System.Collections.Generic;
namespace EasyUI.Web.Mvc.UI
{
    public interface IDatePicker : IInputComponent<DateTime>
    {
        IDictionary<string, object> InputHtmlAttributes { get; }

        Effects Effects { get; set; }

        DatePickerClientEvents ClientEvents { get; }

        bool OpenOnFocus { get; set; }

        string Format { get; set; }
        
        DateTime MinValue { get; set; }

        DateTime MaxValue { get; set; }

        bool Enabled { get; set; }
    }
}
