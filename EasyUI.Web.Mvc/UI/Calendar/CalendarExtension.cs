﻿




namespace EasyUI.Web.Mvc.UI
{
    using System;

    public static class CalendarExtension
    {
        public static DateTime DetermineFocusedDate(this Calendar calendar)
        {
            DateTime focusedDate = DateTime.Today;
            if (calendar.Value.HasValue) {
                focusedDate = calendar.Value.Value;
            }

            if (calendar.MinDate > focusedDate) 
            {
                focusedDate = calendar.MinDate;
            }
            else if (calendar.MaxDate < focusedDate) 
            {
                focusedDate = calendar.MaxDate;
            }

            return focusedDate;
        }
    }
}
