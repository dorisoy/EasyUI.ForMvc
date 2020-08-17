﻿




namespace EasyUI.Web.Mvc.UI
{
    using System;

    using Infrastructure;
    using Resources;

    /// <summary>
    /// Defines the fluent interface for configuring the <see cref="Calendar"/>.
    /// </summary>
    public class CalendarBuilder : ViewComponentBuilderBase<Calendar, CalendarBuilder>, IHideObjectMembers
    {

        /// <summary>
        /// Initializes a new instance of the <see cref="Calendar"/> class.
        /// </summary>
        /// <param name="component">The component.</param>
        public CalendarBuilder(Calendar component)
            : base(component)
        {
        }

        /// <summary>
        /// Sets selected date.
        /// </summary>
        /// <param name="date">DateTime object represents the selected date.</param>
        public CalendarBuilder Value(DateTime date) 
        {
            Guard.IsNotNull(date, "date");

            Component.Value = date;

            return this;
        }

        /// <summary>
        /// Sets selected date.
        /// </summary>
        /// <param name="date">Date passed as string.</param>
        public CalendarBuilder Value(string date)
        {
            Guard.IsNotNullOrEmpty(date, "date");

            DateTime parsedDate;

            if (DateTime.TryParse(date, out parsedDate))
            {
                Component.Value = parsedDate;
            }
            else
            {
                throw new ArgumentException(TextResource.StringNotCorrectDate);
            }
            return this;
        }

        /// <summary>
        /// Sets the smallest possible date, which user can choose.
        /// </summary>
        public CalendarBuilder MinDate(DateTime date)
        {
            Guard.IsNotNull(date, "date");

            Component.MinDate = date;

            return this;
        }

        /// <summary>
        /// Sets the smallest possible date, which user can choose.
        /// </summary>
        public CalendarBuilder MinDate(string date)
        {
            Guard.IsNotNullOrEmpty(date, "date");

            DateTime parsedDate;

            if (DateTime.TryParse(date, out parsedDate))
            {
                Component.MinDate = parsedDate;
            }
            else
            {
                throw new ArgumentException(TextResource.StringNotCorrectDate);
            }
            return this;
        }

        /// <summary>
        /// Sets the biggest possible date, which user can choose.
        /// </summary>
        public CalendarBuilder MaxDate(DateTime date)
        {
            Guard.IsNotNull(date, "date");

            Component.MaxDate = date;

            return this;
        }

        /// <summary>
        /// Sets the smallest possible date, which user can choose.
        /// </summary>
        public CalendarBuilder MaxDate(string date)
        {
            Guard.IsNotNullOrEmpty(date, "date");

            DateTime parsedDate;

            if (DateTime.TryParse(date, out parsedDate))
            {
                Component.MaxDate = parsedDate;
            }
            else
            {
                throw new ArgumentException(TextResource.StringNotCorrectDate);
            }
            return this;
        }

        /// <summary>
        /// Configures the client-side events.
        /// </summary>
        /// <param name="clientEventsAction">The client events action.</param>
        /// <example>
        /// <code lang="CS">
        ///  &lt;%= Html.EasyUI().Calendar()
        ///             .Name("Calendar")
        ///             .ClientEvents(events =>
        ///                 events.OnLoad("onLoad")
        ///             )
        /// %&gt;
        /// </code>
        /// </example>
        public CalendarBuilder ClientEvents(Action<CalendarClientEventsBuilder> clientEventsAction)
        {
            Guard.IsNotNull(clientEventsAction, "clientEventsAction");

            clientEventsAction(new CalendarClientEventsBuilder(Component.ClientEvents, Component.ViewContext));

            return this;
        }

        /// <summary>
        /// Configures the selection settings of the calendar.
        /// </summary>
        /// <param name="selectionAction">SelectAction settings, which includes Action name and IEnumerable of DateTime objects.</param>
        /// <returns></returns>
        public CalendarBuilder Selection(Action<CalendarSelectionSettingsBuilder> selectionAction) 
        {
            Guard.IsNotNull(selectionAction, "selectionAction");

            selectionAction(new CalendarSelectionSettingsBuilder(Component.SelectionSettings, Component.ViewContext));

            return this;
        }
    }
}
