<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().TimePicker()
            .Name("TimePicker")
            .Value(new Nullable<DateTime>())
            .Effects(e => e.Toggle()) 
    %>

    <%= Html.EasyUI().TimePicker()
            .Name("TimePicker2")
            .Interval(15)
            .Value(new Nullable<DateTime>())
            .Min(new DateTime(2000,10,10, 8, 0, 0))
            .Max(new DateTime(2000, 10, 10, 18, 0, 0))
    %>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    function getTimePicker(selector) {
        return $(selector || '#TimePicker').data('tTimePicker');
    }

    test('value method should return selectedValue property', function () {
        var date = new Date(2000, 10, 10, 4, 0, 0, 909);
        var timepicker = getTimePicker();

        timepicker.selectedValue = date;

        var result = timepicker.value();

        equal(date - result, 0);
    });

    test('value method should set internal value property to passed Date object', function () {
        var date = new Date(2000, 10, 10, 14, 0, 0);
        var timepicker = getTimePicker();

        timepicker.value(date);

        equal(+date, +timepicker.selectedValue);
    });

    test('value method should set internal value property passed datetime object', function () {

        var date = new Date(2000, 10, 10, 14, 0, 0, 909);
        var timepicker = getTimePicker();

        timepicker.value(date);

        equal(+date, +timepicker.selectedValue);
    });

    test('value method should set internal selectedValue property to parsed string', function () {

        var date = new Date();

        var timepicker = getTimePicker();
        timepicker.selectedValue = date;

        timepicker.value("2:20 PM");

        var result = new $t.datetime(timepicker.selectedValue);

        equal(result.hours(), 14, "hours");
        equal(result.minutes(), 20, "minutes");
        equal(result.seconds(), 0, "seconds");
    });

    test('value method should set value if min is less then max', function () {

        var timepicker = getTimePicker();

        var date = new Date(2000, 1, 1, 10, 0, 0)

        timepicker.$element.val('');
        timepicker.selectedValue = null;
        timepicker.minValue = new Date(2000, 1, 1, 6, 0, 0)
        timepicker.maxValue = new Date(2000, 1, 1, 18, 0, 0)

        timepicker.value(date);

        var result = new $t.datetime(timepicker.selectedValue);
        notEqual(timepicker.$element.val(), "");
        equal(result.hours(), 10, "hours");
        equal(result.minutes(), 0, "minutes");
        equal(result.seconds(), 0, "seconds");
    });

    test('value method should set value if max is less then min', function () {

        var timepicker = getTimePicker();

        var date = new Date(2000, 1, 1, 4, 0, 0)

        timepicker.$element.val('');
        timepicker.selectedValue = null;
        timepicker.minValue = new Date(2000, 1, 1, 18, 0, 0)
        timepicker.maxValue = new Date(2000, 1, 1, 6, 0, 0)

        timepicker.value(date);

        var result = new $t.datetime(timepicker.selectedValue);

        equal(timepicker.$element.val(), $t.datetime.format(date, timepicker.format));
        equal(result.hours(), 4, "hours");
        equal(result.minutes(), 0, "minutes");
        equal(result.seconds(), 0, "seconds");
    });

    test('value method should no set value if is not in range and if max is less then min', function () {

        var timepicker = getTimePicker();

        var date = new Date(2000, 1, 1, 10, 0, 0)

        timepicker.$element.val('');
        timepicker.selectedValue = null;
        timepicker.minValue = new Date(2000, 1, 1, 18, 0, 0)
        timepicker.maxValue = new Date(2000, 1, 1, 6, 0, 0)

        timepicker.value(date);

        equal(timepicker.$element.val(), "");
        equal(timepicker.selectedValue, null);
    });

    test('value method should no set value if is not in range and if min is less then max', function () {

        var timepicker = getTimePicker();

        var date = new Date(2000, 1, 1, 4, 0, 0)

        timepicker.$element.val('');
        timepicker.selectedValue = null;
        timepicker.minValue = new Date(2000, 1, 1, 6, 0, 0)
        timepicker.maxValue = new Date(2000, 1, 1, 18, 0, 0)

        timepicker.value(date);

        equal(timepicker.$element.val(), "");
        equal(timepicker.selectedValue, null);
    });

    test('value method should update input val', function () {

        var timepicker = getTimePicker();

        var date = new Date(2000, 1, 1, 16, 0, 0)

        timepicker.$element.val('');
        timepicker.selectedValue = null;
        timepicker.minValue = new Date(2000, 1, 1, 6, 0, 0)
        timepicker.maxValue = new Date(2000, 1, 1, 18, 0, 0)

        timepicker.value(date);

        equal(timepicker.$element.val(), $t.datetime.format(date, timepicker.format));
    });

    test('parse method should return null if passed value is null', function () {
        var timepicker = getTimePicker();

        var result = timepicker.parse(null);

        equal(result, null);
    });

    test('parse method should return datetime object created from passed Date', function () {
        var timepicker = getTimePicker();

        var date = new Date(2000, 10, 10, 14, 14, 9);

        var result = timepicker.parse(date);

        equal(+result, +date);
    });

    test('parse method should return passed datetime', function () {
        var timepicker = getTimePicker();

        var date = new Date(2000, 10, 10, 14, 14, 9);

        var result = timepicker.parse(date);

        equal(result, date);
    });

    test('parse method should parse passed string', function () {
        var timepicker = getTimePicker();

        var date = "10:25 PM";

        var result = new $t.datetime(timepicker.parse(date));

        equal(result.hours(), 22, "hours");
        equal(result.minutes(), 25, "minutes");
        equal(result.seconds(), 0, "seconds");
    });

    test('value method should select item depending on passed date object', function () {
        var timepicker = getTimePicker('#TimePicker2');

        timepicker.timeView.dropDown.$items = null;
        var date = new Date(1900, 10, 10, 8, 15, 0);

        timepicker.value(date);

        ok(timepicker.timeView.dropDown.$items.eq(1).hasClass('t-state-selected'));
    });

    test('value method should set value 10 if minValue 4AM and max time 3AM', function () {

        var timepicker = getTimePicker();

        var date = new Date(2000, 1, 1, 10, 0, 0)

        timepicker.$element.val('');
        timepicker.selectedValue = null;
        timepicker.minValue = new Date(2000, 1, 1, 4, 0, 0)
        timepicker.maxValue = new Date(2000, 1, 1, 3, 0, 0)

        timepicker.value(date);

        equal(timepicker.$element.val(), $t.datetime.format(date, timepicker.format));
    });

    test('open method should open dropDown and call value method input val', function () {

        var timepicker = getTimePicker();

        timepicker.close();

        timepicker.open();

        ok(timepicker.timeView.dropDown.isOpened());
    });

    test('close method should close dropDown', function () {
        var timepicker = getTimePicker();

        timepicker.open();

        timepicker.close();

        ok(!timepicker.timeView.dropDown.isOpened());
    });

    test('value method should set empty string to input and deselect items', function () {
        var timepicker = getTimePicker();
        timepicker.open();

        timepicker.value('10:30');

        timepicker.value(null);

        equal(timepicker.$element.val(), '');
        equal(timepicker.timeView.dropDown.$items.filter('t-state-selected').length, 0);
    });

    test('disable method should disable input', function () {
        var timepicker = getTimePicker();

        timepicker.enable();
        timepicker.disable();

        ok($('#TimePicker').attr('disabled'));
    });

    test('disable method should unbind click event of toggle button', function () {
        var timepicker = getTimePicker();

        timepicker.enable();
        timepicker.disable();

        var $icon = $('#TimePicker').closest('.t-timepicker').find('.t-icon');
        equal($icon.data('events').click.toString().indexOf('e.preventDefault();'), -1);
    });

    test('enable method should enable input', function () {
        var timepicker = getTimePicker();

        timepicker.disable();
        timepicker.enable();

        ok(!$('#TimePicker').attr('disabled'));
    });

    test('enable method should bind click event of toggle button', function () {
        var timepicker = getTimePicker();

        timepicker.disable();
        timepicker.enable();

        var $icon = $('#TimePicker').closest('.t-timepicker').find('.t-icon');

        ok(null !== $icon.data('events').click);
    });

    test('disable method should add state disabled', function () {
        var timepicker = getTimePicker();

        timepicker.enable();
        timepicker.disable();

        ok($('#TimePicker').closest('.t-timepicker').hasClass('t-state-disabled'));
    });

    test('enable method should remove state disabled', function () {
        var timepicker = getTimePicker();

        timepicker.disable();
        timepicker.enable();

        ok(!$('#TimePicker').closest('.t-timepicker').hasClass('t-state-disabled'));
    });

    test('internal change method should set value to minValue if parsedValue close to min', function () {
        var timepicker = getTimePicker();
        var oldMinValue = timepicker.minValue;
        var oldMaxValue = timepicker.maxValue;

        timepicker.minValue = new Date(2000, 10, 10, 13, 30, 0);
        timepicker.maxValue = new Date(2000, 10, 10, 18, 0, 0);

        timepicker._update('10:10 AM');

        equal(+timepicker.selectedValue, +timepicker.minValue, 'selectedDate is not equal to MinValue');

        timepicker.minValue = oldMinValue;
        timepicker.maxValue = oldMaxValue;
    });

    test('internal change method should set value to maxValue if parsedValue close to max', function () {
        var timepicker = getTimePicker();
        var oldMinValue = timepicker.minValue;
        var oldMaxValue = timepicker.maxValue;

        timepicker.minValue = new Date(2000, 10, 10, 13, 30, 0);
        timepicker.maxValue = new Date(2000, 10, 10, 18, 0, 0);

        timepicker._update('7:10 PM');
        
        equal(+timepicker.selectedValue, +timepicker.maxValue, 'selectedDate is not equal to MaxValue');

        timepicker.minValue = oldMinValue;
        timepicker.maxValue = oldMaxValue;
    });

    test('internal change method should set value to maxValue if parsedValue close to max and max is less then minValue', function () {
        var timepicker = getTimePicker();
        var oldMinValue = timepicker.minValue;
        var oldMaxValue = timepicker.maxValue;

        timepicker.minValue = new Date(2000, 10, 10, 22, 30, 0);
        timepicker.maxValue = new Date(2000, 10, 10, 10, 0, 0);

        timepicker._update('10:10 AM');

        equal(+timepicker.selectedValue, +timepicker.maxValue, 'selectedDate is not equal to MaxValue');

        timepicker.minValue = oldMinValue;
        timepicker.maxValue = oldMaxValue;
    });

    test('internal change method should set value to minValue if parsedValue close to min and max is less then minValue', function () {
        var timepicker = getTimePicker();
        var oldMinValue = timepicker.minValue;
        var oldMaxValue = timepicker.maxValue;

        timepicker.minValue = new Date(2000, 10, 10, 22, 30, 0);
        timepicker.maxValue = new Date(2000, 10, 10, 10, 0, 0);

        timepicker._update('9:10 PM');

        equal(+timepicker.selectedValue, +timepicker.minValue, 'selectedDate is not equal to MinValue');

        timepicker.minValue = oldMinValue;
        timepicker.maxValue = oldMaxValue;
    });

    test('internal value method should set selectedValue to passed val', function () {
        var timepicker = getTimePicker();

        var value = new Date(2000, 10, 10, 14, 14, 0);

        timepicker._value(value);

        equal(+value, +timepicker.selectedValue, 'selectedValue was not set');
    });

    test('internal value method should set selectedValue to null', function () {
        var timepicker = getTimePicker();

        timepicker._value(null);

        ok(null === timepicker.selectedValue);
    });

    test('internal value method should call timeView value method', function () {
        var passed;
        var timepicker = getTimePicker();
        var oldM = timepicker.timeView.value;
        var value = new Date(2000, 10, 10, 14, 14, 0);

        timepicker.timeView.value = function (val) { passed = val };

        timepicker._value(value);

        ok(undefined !== passed);

        timepicker.timeView.value = oldM;
    });

    test('internal value method should set error state if parameter is null and input is not empty', function () {
        var timepicker = getTimePicker();

        timepicker.$element.val('invalid');

        timepicker._value(null);

        ok(timepicker.$element.hasClass('t-state-error'), 't-error-state is not applied');
    });

    test('internal value method should remove error if input is empty', function () {
        var timepicker = getTimePicker();

        timepicker.$element.val('');

        timepicker._value(null);

        ok(!timepicker.$element.hasClass('t-state-error'), 't-error-state is not applied');
    });

    test('internal value method should remove error if correct date is passed', function () {
        var timepicker = getTimePicker();

        var value = new Date(2000, 10, 10, 14, 14, 0);

        timepicker._value(value);

        ok(!timepicker.$element.hasClass('t-state-error'), 't-error-state is not applied');
    });
        
</script>

</asp:Content>