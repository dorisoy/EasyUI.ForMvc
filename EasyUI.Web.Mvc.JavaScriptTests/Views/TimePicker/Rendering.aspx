<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().TimePicker()
            .Name("TimePicker1")
            .Min(new DateTime(2010, 1, 1, 4, 0, 0))
            .Max(new DateTime(2010, 1, 14, 3, 0, 0))
            .Format("h:mm tt")
            .Interval(30)
            .Effects(e => e.Toggle())
            .Value(new DateTime(2010, 1, 1, 10, 0, 0))
    %>

    <%= Html.EasyUI().TimePicker().Name("TimePicker2")
            .Effects(e=>e.Toggle())
            .Value(new DateTime(2000, 10, 10, 10, 0, 0))
    %>

    <%= Html.EasyUI().TimePicker().Name("TimePickerWithInputAttr")
            .Effects(e=>e.Toggle())
            .InputHtmlAttributes(new {value = "11:00 AM"})
    %>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    function getTimePicker(selector) {
        return $('#TimePicker1' || selector).data('tTimePicker');
    }

    test('open method should fill list', function () {
        var timePicker = getTimePicker();

        timePicker.timeView.dropDown.$items = null;

        timePicker.open();

        ok(timePicker.timeView.dropDown.$items.length != 0);
    });

    test('max method should rebind items list', function () {
        var timepicker = getTimePicker();

        timepicker.max(new Date(2000, 1, 1, 3, 0, 0))

        var $items = timepicker.timeView.dropDown.$items;

        equal($($items[$items.length - 1]).text(), $t.datetime.format(timepicker.maxValue, timepicker.format));
    });

    test('min method should rebind items list', function () {
        var timepicker = getTimePicker();

        timepicker.min(new Date(2000, 1, 1, 10, 0, 0))

        var $items = timepicker.timeView.dropDown.$items;

        equal($($items[0]).text(), $t.datetime.format(timepicker.minValue, timepicker.format));
    });

    test('open method with empty input should open dropDownList', function () {
        var timePicker = getTimePicker();

        timePicker.open();

        ok(timePicker.timeView.dropDown.isOpened());
    });

        test('timeView value should be called if selectedValue is not null', function () {
            var timepicker = $('#TimePicker2').data('tTimePicker');
            timepicker.open();

            var time = timepicker.timeView.dropDown.$items.filter('.t-state-selected');

            equal('10:00 AM', time.text(), 'not correct day is selected');
        });

        test('timeView value should be called if input has value', function () {
            var timepicker = $('#TimePickerWithInputAttr').data('tTimePicker');
            timepicker.open();

            var time = timepicker.timeView.dropDown.$items.filter('.t-state-selected');

            equal('11:00 AM', time.text(), 'not correct day is selected');
        });

        test('error class should be added on blur', function () {
            var timepicker = $('#TimePickerWithInputAttr').data('tTimePicker'),
                element = timepicker.$element;
            
            timepicker.close();   
            element.focus().val("wrong value").blur();
            
            setTimeout(function() {
                start();
                ok(element.hasClass('t-state-error'));
            }, 200);

            stop(300);
        });

</script>

</asp:Content>