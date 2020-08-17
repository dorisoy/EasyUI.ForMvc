namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System;
    using System.ComponentModel;

    [AutoPopulateSourceCode]
    [PopulateProductSiteMap(SiteMapName = "examples", ViewDataKey = "easyui.mvc.examples")]
    public partial class DatePickerController : Controller
    {
    }

    public class DatePickerAttributes
    {
        public DateTime? SelectedDate
        {
            get;
            set;
        }

        public DateTime? MinDate 
        { 
            get; 
            set; 
        }

        public DateTime? MaxDate 
        { 
            get; 
            set; 
        }

        public bool? ShowButton 
        { 
            get; 
            set; 
        }

        public bool? OpenOnFocus
        {
            get;
            set;
        }
    }

    public class TimePickerAttributes
    {
        public DateTime? SelectedDate 
        { 
            get; 
            set; 
        }

        public DateTime? MinTime 
        { 
            get; 
            set; 
        }

        public DateTime? MaxTime 
        {
            get; 
            set; 
        }

        public bool? ShowButton 
        { 
            get; 
            set; 
        }

        public int? Interval 
        { 
            get; 
            set; 
        }

        public bool? OpenOnFocus
        {
            get;
            set;
        }
    }

    public class DateTimePickerAttributes
    {
        public DateTime? SelectedDate
        {
            get;
            set;
        }

        public DateTime? MinDate
        {
            get;
            set;
        }

        public DateTime? MaxDate
        {
            get;
            set;
        }

        public int? Interval
        {
            get;
            set;
        }
    }
}