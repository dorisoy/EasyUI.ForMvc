namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Web.Mvc;

    public partial class DatePickerController : Controller
    {
        public ActionResult FirstLook(FirstLookModelView viewModel)
        {
            viewModel.DatePickerAttributes.SelectedDate = viewModel.DatePickerAttributes.SelectedDate ?? DateTime.Today;
            viewModel.DatePickerAttributes.MinDate = viewModel.DatePickerAttributes.MinDate ?? new DateTime(1900, 1, 1);
            viewModel.DatePickerAttributes.MaxDate = viewModel.DatePickerAttributes.MaxDate ?? new DateTime(2099, 12, 31);
            viewModel.DatePickerAttributes.ShowButton = viewModel.DatePickerAttributes.ShowButton ?? true;
            viewModel.DatePickerAttributes.OpenOnFocus = viewModel.DatePickerAttributes.OpenOnFocus ?? false;

            viewModel.TimePickerAttributes.SelectedDate = viewModel.TimePickerAttributes.SelectedDate ?? new DateTime(2010, 1, 1, 10, 0, 0);
            viewModel.TimePickerAttributes.MinTime = viewModel.TimePickerAttributes.MinTime ?? new DateTime(2010, 1, 1, 8, 0, 0);
            viewModel.TimePickerAttributes.MaxTime = viewModel.TimePickerAttributes.MaxTime ?? new DateTime(2010, 1, 1, 18, 0, 0);
            viewModel.TimePickerAttributes.ShowButton = viewModel.TimePickerAttributes.ShowButton ?? true;
            viewModel.TimePickerAttributes.Interval = viewModel.TimePickerAttributes.Interval ?? 30;
            viewModel.TimePickerAttributes.OpenOnFocus = viewModel.TimePickerAttributes.OpenOnFocus ?? false;

            viewModel.DateTimePickerAttributes.SelectedDate = viewModel.DateTimePickerAttributes.SelectedDate ?? new DateTime(2010, 1, 1, 10, 0, 0);
            viewModel.DateTimePickerAttributes.MinDate = viewModel.DateTimePickerAttributes.MinDate ?? new DateTime(1900, 1, 1, 8, 0, 0);
            viewModel.DateTimePickerAttributes.MaxDate = viewModel.DateTimePickerAttributes.MaxDate ?? new DateTime(2099, 12, 31, 18, 0, 0);
            viewModel.DateTimePickerAttributes.Interval = viewModel.DateTimePickerAttributes.Interval ?? 30;

            return View(viewModel);
        }
    }

    public class FirstLookModelView
    {
        public FirstLookModelView()
        {
            DatePickerAttributes = new DatePickerAttributes();
            TimePickerAttributes = new TimePickerAttributes();
            DateTimePickerAttributes = new DateTimePickerAttributes();
        }

        public DatePickerAttributes DatePickerAttributes { get; set; }
        public TimePickerAttributes TimePickerAttributes { get; set; }
        public DateTimePickerAttributes DateTimePickerAttributes { get; set; }
    }
}