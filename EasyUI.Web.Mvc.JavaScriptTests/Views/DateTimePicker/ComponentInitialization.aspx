<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        .t-state-focus
        {
            border-color: Red !important;
            border-width: 2px !important;
        }
    </style>
    
    <%= Html.EasyUI().DateTimePicker()
            .Name("DateTimePicker")
            .Effects(e => e.Toggle())
            .Value(DateTime.Now)
    %>

        <%= Html.EasyUI().DateTimePicker().Name("DateTimePicker2")
            .Effects(e=>e.Toggle())
            .Value(new DateTime(2000, 10, 10, 10, 0, 0))
    %>

    <%= Html.EasyUI().DateTimePicker().Name("DateTimePickerWithInputAttr")
            .Effects(e=>e.Toggle())
            .InputHtmlAttributes(new {value = "12/12/2000 11:00 AM"})
    %>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    function getDateTimePicker() {
        return $('#DateTimePicker').data('tDateTimePicker');
    }

    test('initialized DateTimePicker should create timeView with proper settings', function () {
        var datetimepicker = getDateTimePicker();
        var timeView = datetimepicker.timeView;

        ok(undefined !== timeView, 'timeView is not undefined');
        ok(undefined !== timeView.onChange);
        ok(undefined !== timeView.onNavigateWithOpenPopup);
        equal(timeView.effects.list[0].name, datetimepicker.effects.list[0].name, 'correct effects are set');
        equal(timeView.dropDownAttr, datetimepicker.dropDownAttr, 'correct dropDownAttr is set');
        equal(timeView.format, datetimepicker.timeFormat, 'correct timeFormat is set');
        equal(timeView.interval, datetimepicker.interval, 'correct interval is set');
        equal(+datetimepicker.startTimeValue, +timeView.minValue, 'correct minValue is set');
        equal(+datetimepicker.endTimeValue, +timeView.maxValue, 'correct maxValue is set');
    });

    test('initialized DateTimePicker should create dateView with proper settings', function () {
        var datetimepicker = getDateTimePicker();
        var dateView = datetimepicker.dateView;

        ok(undefined !== dateView, 'timeView is undefined');
        ok(undefined !== dateView.onChange);
        equal(dateView.effects.list[0].name, datetimepicker.effects.list[0].name, 'correct effects are set');
        equal(+datetimepicker.minValue, +dateView.minValue, 'correct minValue is set');
        equal(+datetimepicker.maxValue, +dateView.maxValue, 'correct maxValue is set');
        equal(+datetimepicker.selectedValue, +dateView.selectedValue, 'correct selectedValue is set');
    });

        test('dateView value should be called if selectedValue is not null', function () {
            var datetimepicker = $('#DateTimePicker2').data('tDateTimePicker');
            datetimepicker.open();

            var day = datetimepicker.dateView.$calendar.find('.t-state-selected');

            equal('10', day.text(), 'not correct day is selected');
        });

        test('dateView value should be called if input has value', function () {
            var datetimepicker = $('#DateTimePickerWithInputAttr').data('tDateTimePicker');
            datetimepicker.open();

            var day = datetimepicker.dateView.$calendar.find('.t-state-selected');

            equal('12', day.text(), 'not correct day is selected');
        });

        test('timeView value should be called if selectedValue is not null', function () {
            var datetimepicker = $('#DateTimePicker2').data('tDateTimePicker');
            datetimepicker.open();

            var time = datetimepicker.timeView.dropDown.$items.filter('.t-state-selected');

            equal('10:00 AM', time.text(), 'not correct day is selected');
        });

        test('timeView value should be called if input has value', function () {
            var datetimepicker = $('#DateTimePickerWithInputAttr').data('tDateTimePicker');
            datetimepicker.open();

            var time = datetimepicker.timeView.dropDown.$items.filter('.t-state-selected');

            equal('11:00 AM', time.text(), 'not correct day is selected');
        });

        test('error class should be added on blur', function () {
            var datetimepicker = $('#DateTimePickerWithInputAttr').data('tDateTimePicker');
                element = datetimepicker.$element;
            
            datetimepicker.close("date");
            datetimepicker.close("time");

            element.focus().val("wrong value").blur();
            
            setTimeout(function() {
                start();
                ok(element.hasClass('t-state-error'));
            }, 200);

            stop(300);
        });

</script>

</asp:Content>