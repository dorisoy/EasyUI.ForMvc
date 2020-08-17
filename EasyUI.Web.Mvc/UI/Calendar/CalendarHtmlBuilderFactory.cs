




namespace EasyUI.Web.Mvc.UI
{
    public class CalendarHtmlBuilderFactory : ICalendarHtmlBuilderFactory
    {
        public ICalendarHtmlBuilder Create(Calendar calendar)
        {
            return new CalendarHtmlBuilder(calendar);
        }
    }
}
