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
    
    <h2>Keyboard support</h2>
    
    <script type="text/javascript">

        function getDateTimePicker() {
            return $('#DateTimePicker').data('tDateTimePicker');
        }

    </script>
    
    <%= Html.EasyUI().DateTimePicker()
            .Name("DateTimePicker")
            .HtmlAttributes(new { style = "width:300px" })
            .Effects(e => e.Toggle()) 
    %>

    <%= Html.EasyUI().DateTimePicker()
        .Name("DateTimePicker1")
        .HtmlAttributes(new { style = "width:300px" })
        .Effects(e => e.Toggle()) 
    %>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



    test('internal toggleDateView should call change and open if dateView is closed', function () {
        var isOpenCalled = false;
        var isCloseCalled = false;

        var openValue;
        var closeValue;

        var dateTimePicker = getDateTimePicker();

        var oldOpen = dateTimePicker._open;
        var oldClose = dateTimePicker._close;

        dateTimePicker._open = function (value) { isOpenCalled = true; openValue = value; };
        dateTimePicker._close = function (value) { isCloseCalled = true; closeValue = value; };

        dateTimePicker.close('date');
        dateTimePicker.$element.val('');
        dateTimePicker._toggleDateView();

        ok(isOpenCalled, '_open method was not called');
        equal(openValue, 'date', '_open method was not called with "date" argument');
        ok(isCloseCalled, '_close method was not called');
        equal(closeValue, 'time', '_close method was not called with "time" argument');

        dateTimePicker._open = oldOpen;
        dateTimePicker._close = oldClose;
    });

    test('internal toggleTimeView should call change and open if timeView is closed', function () {
        var isOpenCalled = false;
        var isCloseCalled = false;
        
        var openValue;
        var closeValue;
        
        var dateTimePicker = getDateTimePicker();

        var oldOpen = dateTimePicker._open;
        var oldClose = dateTimePicker._close;
        
        dateTimePicker._open = function (value) { isOpenCalled = true; openValue = value; };
        dateTimePicker._close = function (value) { isCloseCalled = true; closeValue = value; };
        
        dateTimePicker.close('time');
        dateTimePicker.$element.val('');
        dateTimePicker._toggleTimeView();

        ok(isOpenCalled, '_open method was not called');
        equal(openValue, 'time', '_open method was not called with "time" argument');
        ok(isCloseCalled, '_close method was not called');
        equal(closeValue, 'date', '_close method was not called with "date" argument');
        
        dateTimePicker._open = oldOpen;
        dateTimePicker._close = oldClose;
    });

    test('internal toggleDateView should call close with date argument', function () {
        var isCloseCalled = false;
        var closeValue;

        var dateTimePicker = getDateTimePicker();
        var oldClose = dateTimePicker._close;

        dateTimePicker._close = function (value) { isCloseCalled = true; closeValue = value; };

        dateTimePicker.open('date');
        dateTimePicker._toggleDateView();

        ok(isCloseCalled, '_close method was not called');
        equal(closeValue, 'date', '_close method was not called with "date" argument');

        dateTimePicker._close = oldClose;
    });

    test('internal toggleTimeView should call close with date argument', function () {
        var isCloseCalled = false;
        var closeValue;

        var dateTimePicker = getDateTimePicker();
        var oldClose = dateTimePicker._close;

        dateTimePicker._close = function (value) { isCloseCalled = true; closeValue = value; };

        dateTimePicker.open('time');

        dateTimePicker._toggleTimeView();

        ok(isCloseCalled, '_close method was not called');
        equal(closeValue, 'time', '_close method was not called with "time" argument');

        dateTimePicker._close = oldClose;
    });

    test('internal open method should call internal trigger with date argument if dateView is closed', function () {

        var arg1, arg2;
        var dateTimePicker = getDateTimePicker();

        var oldTrigger = dateTimePicker._trigger;
        dateTimePicker._trigger = function (popup, value) { arg1 = popup, arg2 = value };
        dateTimePicker.dateView.close();

        dateTimePicker._open('date');

        equal(arg1, 'date', 'trigger method was not called with correct popup');
        equal(arg2, 'open', 'trigger method was not called with correct method');

        dateTimePicker._trigger = oldTrigger;
    });

    test('internal open method should call internal trigger with time argument if dateView is closed', function () {

        var arg1, arg2;
        var dateTimePicker = getDateTimePicker();

        var oldTrigger = dateTimePicker._trigger;
        dateTimePicker._trigger = function (popup, value) { arg1 = popup, arg2 = value };
        dateTimePicker.timeView.close();

        dateTimePicker._open('time');

        equal(arg1, 'time', 'trigger method was not called with correct popup');
        equal(arg2, 'open', 'trigger method was not called with correct method');

        dateTimePicker._trigger = oldTrigger;
    });

    test('internal close method should call internal trigger with date argument if dateView is opened', function () {

        var arg1, arg2;
        var dateTimePicker = getDateTimePicker();

        var oldTrigger = dateTimePicker._trigger;
        dateTimePicker._trigger = function (popup, value) { arg1 = popup, arg2 = value };
        var $element = dateTimePicker.$element;
        dateTimePicker.dateView.open({
            offset: $element.offset(),
            outerHeight: $element.outerHeight(),
            outerWidth: $element.outerWidth(),
            zIndex: $.easyui.getElementZIndex($element[0])
        });

        dateTimePicker._close('date');

        equal(arg1, 'date', 'trigger method was not called with correct popup');
        equal(arg2, 'close', 'trigger method was not called with correct method');

        dateTimePicker._trigger = oldTrigger;
    });

    test('internal close method should call internal trigger with time argument if dateView is opened', function () {

        var arg1, arg2;
        var dateTimePicker = getDateTimePicker();

        var oldTrigger = dateTimePicker._trigger;
        dateTimePicker._trigger = function (popup, value) { arg1 = popup, arg2 = value };
        var $element = dateTimePicker.$element;
        dateTimePicker.timeView.open({
            offset: $element.offset(),
            outerHeight: $element.outerHeight(),
            outerWidth: $element.outerWidth(),
            zIndex: $.easyui.getElementZIndex($element[0])
        });
        dateTimePicker._close('time');

        equal(arg1, 'time', 'trigger method was not called with correct popup');
        equal(arg2, 'close', 'trigger method was not called with correct method');

        dateTimePicker._trigger = oldTrigger;
    });

    test('internal trigger should call open with date parameter', function () {
        var pop;
        var dateTimePicker = getDateTimePicker();
        var old = dateTimePicker.open;

        dateTimePicker.open = function (popup) { pop = popup; };

        dateTimePicker._trigger('date', 'open');

        equal(pop, 'date', 'open was not called with "date" parapm');

        dateTimePicker.open = old;
    });

    test('internal trigger should call open with time parameter', function () {
        var pop;
        var dateTimePicker = getDateTimePicker();
        var old = dateTimePicker.open;

        dateTimePicker.open = function (popup) { pop = popup; };

        dateTimePicker._trigger('time', 'open');

        equal(pop, 'time', 'open was not called with "time" parapm');

        dateTimePicker.open = old;
    });

    test('internal trigger should call close with date parameter', function () {
        var pop;
        var dateTimePicker = getDateTimePicker();
        var old = dateTimePicker.close;

        dateTimePicker.close = function (popup) { pop = popup; };

        dateTimePicker._trigger('date', 'close');

        equal(pop, 'date', 'open was not called with "date" parapm');

        dateTimePicker.close = old;
    });

    test('internal trigger should call close with time parameter', function () {
        var pop;
        var dateTimePicker = getDateTimePicker();
        var old = dateTimePicker.close;

        dateTimePicker.close = function (popup) { pop = popup; };

        dateTimePicker._trigger('time', 'close');

        equal(pop, 'time', 'open was not called with "time" parapm');

        dateTimePicker.close = old;
    });

    test('disable method should add disable attr', function () {
        var dateTimePicker = getDateTimePicker();

        dateTimePicker.disable();

        equal(dateTimePicker.$element.attr('disabled'), 'disabled', 'input is not disabled')

        dateTimePicker.enable();
    });

    test('disable method should add enable attr', function () {
        var dateTimePicker = getDateTimePicker();

        dateTimePicker.enable();

        ok(!dateTimePicker.$element.attr('disabled'), 'input is not disabled')

        dateTimePicker.disable();
    });

    test('min method should set minDate property and call dateView min method', function () {
        var isCalled = false;
        var dateTimePicker = getDateTimePicker();

        var oldM = dateTimePicker.dateView.min;
        dateTimePicker.dateView.min = function () { isCalled = true; }

        dateTimePicker.min('10/10/1904');

        var minValue = new $.easyui.datetime(dateTimePicker.minValue);

        ok(isCalled);
        equal(minValue.year(), 1904, 'year');
        equal(minValue.month(), 9, 'month');
        equal(minValue.date(), 10, 'day');

        dateTimePicker.dateView.min = oldM;
    });

    test('min method should not set minValue if it is bigger then maxValue', function () {
        var dateTimePicker = $('#DateTimePicker1').data('tDateTimePicker');
        var oldMin = dateTimePicker.min();

        dateTimePicker.max(new Date(1999, 10, 10));
        dateTimePicker.min(new Date(2000, 10, 10));

        ok(oldMin - dateTimePicker.min() == 0, "min date was incorrectly updated");
    });

    test('max method should not set maxValue if it is less then minValue', function () {
        var dateTimePicker = getDateTimePicker();
        var oldMax = dateTimePicker.max();

        dateTimePicker.min(new Date(2000, 10, 10));
        dateTimePicker.max(new Date(1999, 10, 10));

        ok(oldMax - dateTimePicker.max() == 0, "min date was incorrectly updated");
    });

    test('min method should set value to minValue if value is not in range', function () {
        var dateTimePicker = getDateTimePicker();
        dateTimePicker.min(new Date(1899, 10, 10));
        dateTimePicker.max(new Date(2100, 10, 10));

        dateTimePicker.endTime("10/10/2000 10:00 PM");
        dateTimePicker.value("10/10/2000 10:00 AM");

        dateTimePicker.startTime("10/10/2000 11:00 AM");

        equal(dateTimePicker.value().getHours(), dateTimePicker.startTime().getHours(), "hours were not updated");
        equal(dateTimePicker.value().getMinutes(), dateTimePicker.startTime().getMinutes(), "minutes were not updated");
    });

    test('max method should set value to maxValue if value is not in range', function () {
        var dateTimePicker = getDateTimePicker();

        dateTimePicker.startTime("10/10/2000 8:00 AM");
        dateTimePicker.value("10/10/2000 10:00 AM");

        dateTimePicker.endTime("10/10/2000 9:00 AM");

        equal(dateTimePicker.value().getHours(), dateTimePicker.endTime().getHours(), "hours were not updated");
        equal(dateTimePicker.value().getMinutes(), dateTimePicker.endTime().getMinutes(), "minutes were not updated");
    });

</script>

</asp:Content>