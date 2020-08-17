<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <input id="testInput" />

     <% Html.EasyUI().ScriptRegistrar()
            .DefaultGroup(group => group.Add("easyui.common.js")
                                        .Add("easyui.calendar.js")
                                        .Add("easyui.datepicker.js")); 
     %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">


    var views = {
        Month: 0,
        Year: 1,
        Decade: 2,
        Century: 3
    }

    var dv;
    var isRtl;
    var $input;
    var position;


    function configureCalendar(viewedMonth, currentView) {
        var calendar = dv._getCalendar();

        if (viewedMonth) calendar.viewedMonth = new $.easyui.datetime(viewedMonth.value ? viewedMonth.value : viewedMonth);
        calendar.currentView = $.easyui.calendar.views[currentView];
        calendar.stopAnimation = true;

        return calendar;
    }

    module("DatePicker / DateView", {
        setup: function () {
            $input = $('#testInput');
            isRtl = $('#testInput').closest('.t-rtl').length;

            dv = new $t.dateView({
                minValue: new Date(1800, 10, 10),
                maxValue: new Date(2100, 10, 10),
                selectedValue: null,
                effects: $t.fx.toggle.defaults(),
                isRtl: isRtl
            });

            dv.$calendar.data('tCalendar').stopAnimation = true;

            position = {
                offset: $input.offset(),
                outerHeight: $input.outerHeight(),
                outerWidth: $input.outerWidth(),
                zIndex: $t.getElementZIndex($input[0])
            }
        }
    });

    test('initializing dateview with selectedValue should set focusedValue to it', function () {
        var selectedDate = new Date(2010, 10, 10);
        var dateView = new $t.dateView({
            minValue: new Date(1800, 10, 10),
            maxValue: new Date(2100, 10, 10),
            selectedValue: selectedDate,
            effects: $t.fx.toggle.defaults(),
            isRtl: isRtl
        });

        equal(dateView.focusedValue.getFullYear(), selectedDate.getFullYear(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getMonth(), selectedDate.getMonth(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getDate(), selectedDate.getDate(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getHours(), selectedDate.getHours(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getMinutes(), selectedDate.getMinutes(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getSeconds(), selectedDate.getSeconds(), 'focusedValue was not defined correctly');
    });

    test('initializing dateview should set focusedValue to minDate if minDate is bigger then today', function () {
        var minDate = new $t.datetime();
        minDate = $t.datetime.add(minDate, 10000);

        var dateView = new $t.dateView({
            minValue: minDate.toDate(),
            maxValue: new Date(2100, 10, 10),
            selectedValue: null,
            effects: $t.fx.toggle.defaults(),
            isRtl: isRtl
        });

        equal(dateView.focusedValue.getFullYear(), minDate.year(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getMonth(), minDate.month(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getDate(), minDate.date(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getHours(), minDate.hours(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getMinutes(), minDate.minutes(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getSeconds(), minDate.seconds(), 'focusedValue was not defined correctly');
    });

    test('initializing dateview should set focusedValue to maxDate if maxDate is less then today', function () {
        var maxDate = new $t.datetime();
        $t.datetime.modify(maxDate, -10000);

        var dateView = new $t.dateView({
            minValue: new Date(1800, 10, 10),
            maxValue: maxDate.toDate(),
            selectedValue: null,
            effects: $t.fx.toggle.defaults(),
            isRtl: isRtl
        });

        equal(dateView.focusedValue.getFullYear(), maxDate.year(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getMonth(), maxDate.month(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getDate(), maxDate.date(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getHours(), maxDate.hours(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getMinutes(), maxDate.minutes(), 'focusedValue was not defined correctly');
        equal(dateView.focusedValue.getSeconds(), maxDate.seconds(), 'focusedValue was not defined correctly');
    });

    test('creating dateView will create sharedCalendar if it is not created yet', function () {
        var dateView = new $t.dateView({
            minValue: new Date(2000, 10, 10),
            maxValue: new Date(2010, 10, 10),
            selectedValue: null,
            effects: $t.fx.toggle.defaults(),
            isRtl: $('#testInput').closest('.t-rtl').length
        });

        notEqual(dateView.$calendar, undefined, '$calendar is undefined');
    });

    test('second dateView should use shared calendar', function () {
        var options = {
            minValue: new Date(2000, 10, 10),
            maxValue: new Date(2010, 10, 10),
            selectedValue: new Date(2005, 10, 10),
            effects: $t.fx.toggle.defaults(),
            isRtl: $('#testInput').closest('.t-rtl').length
        };

        var dateView = new $t.dateView(options);
        var dateView2 = new $t.dateView(options);

        equal(dateView2.$calendar, dateView.$calendar);
    });

    test('open method should show calendar on correct position', function () {
        dv.open(position);

        var $animationContainer = dv.$calendar.parent();

        equal($animationContainer.css('position'), 'absolute', 'position');
        equal($animationContainer.css('direction'), 'ltr', 'direction');
        equal($animationContainer.css('display'), 'block', 'display');
        equal($animationContainer.css('zIndex'), position.zIndex, 'zindex');
    });

    test('assignToNewDateView should update sharedCalendar', function () {
        var isCalled = false;
        var options = {
            minValue: new Date(1900, 10, 10),
            maxValue: new Date(2100, 10, 10),
            selectedValue: new Date(2000, 0, 1),
            effects: $t.fx.toggle.defaults(),
            isRtl: $('#testInput').closest('.t-rtl').length
        };

        var calendar = dv.$calendar.data('tCalendar');

        var oldFunc = calendar.updateSelection;
        calendar.updateSelection = function () { isCalled = true; };

        var dateView = new $t.dateView(options);

        dateView._reassignSharedCalendar();

        ok(isCalled, 'Calendar update selection is not called');
        equal(calendar.selectedValue - options.selectedValue, 0, 'selectedValue is not equal');
        equal(calendar.minDate - options.minValue, 0, 'minValue is not equal');
        equal(calendar.maxDate - options.maxValue, 0, 'maxValue is not equal');

        calendar.updateSelection = oldFunc;
    });

    test('isOpened should return true if calendar visible', function () {
        dv.close();
        dv.open(position);

        ok(dv.isOpened());
    });

    test('isOpened should return false if calendar is not visible', function () {
        dv.open(position);

        dv.close();

        ok(!dv.isOpened());
    });

    test('value method should set selectedValue of dateView', function () {
        var date = new Date(2007, 7, 7);

        dv.value(date);

        equal(dv.selectedValue - date, 0, 'selectedValue was not updated');
        equal(dv.focusedValue - date, 0, 'focusedValue was not updated');
    });

    test('value method should set selectedValue to null if value is null', function () {
        dv.value(null);

        var today = new $t.datetime();

        var focusedValue = new $.easyui.datetime(dv.focusedValue);

        equal(dv.selectedValue, null, 'selectedValue is not set to null');
        equal(focusedValue.year(), today.year(), 'focusedValue is not set to today');
        equal(focusedValue.month(), today.month(), 'focusedValue is not set to today');
        equal(focusedValue.date(), today.date(), 'focusedValue is not set to today');
        equal(dv._getCalendar().value(), null, 'calendar was not updated');
    });

    test('value method should call calendar value method and focusDate', function () {
        var isCalled = false;
        var isMethodCalled = false;
        var date = new Date(2007, 7, 7);

        var calendar = dv._getCalendar();
        var oldValue = calendar.value;
        calendar.value = function () { isCalled = true; }

        var oldFunc = $t.calendar.focusDate;
        $t.calendar.focusDate = function () { isMethodCalled = true; }

        dv.value(date);

        ok(isCalled, 'value method is not called');
        ok(isMethodCalled, 'focus method is not called');

        calendar.value = oldValue;
        $t.calendar.focusDate = oldFunc;
    });

    test('minValue method should set minValue close and null sharedCalendar', function () {
        var isCalled = false;

        var date = new Date(1907, 7, 7);

        var method = dv._reassignSharedCalendar;

        dv._reassignSharedCalendar = function () { isCalled = true; }
        dv.open(position);
        dv.min(date);

        ok(isCalled, 'create calendar was not called');
        equal(+dv.minValue, +date, 'minValue is not set');

        dv._reassignSharedCalendar = method;
    });

    test('page down should navigate to future', function () {

        var date = new Date(2004, 6, 28);

        dv.focusedValue = new Date(date);
        dv.open(position);

        dv.navigate({ keyCode: 34, preventDefault: function () { } });

        equal(dv.focusedValue - new Date(2004, 7, 28), 0, 'focused date is not one month in the futute');
    });

    test('page up should navigate to past', function () {

        var date = new Date(2004, 6, 28);

        dv.focusedValue = new Date(date);
        dv.open(position);

        dv.navigate({ keyCode: 33, preventDefault: function () { } });

        equal(dv.focusedValue - new Date(2004, 5, 28), 0, 'focused date is not one month earlier');
    });

    test('home button should focus first day of month', function () {

        var date = new Date(2004, 6, 28);

        dv.focusedValue = new Date(date);
        dv.open(position);

        dv.navigate({ keyCode: 36, preventDefault: function () { } });

        equal(dv.focusedValue - new Date(2004, 6, 1), 0, 'first day of the month is not focused');
    });

    test('end button should focus last day of month', function () {

        var date = new Date(2004, 6, 28);

        dv.focusedValue = new Date(date);
        dv.open(position);

        dv.navigate({ keyCode: 35, preventDefault: function () { } });

        equal(dv.focusedValue - new Date(2004, 6, 31), 0, 'last day of the month is not focused');
    });

    test('alt and down arrow should open calendar', function () {

        var date = new Date(2004, 6, 28);

        dv.focusedValue = new Date(date);
        dv.open(position);

        dv.navigate({ keyCode: 35, altKey: true, preventDefault: function () { } });

        ok(dv.$calendar.is(':visible'));
    });

    test('if datepicker focused ctrl and left arrow should navigate to passed month', function () {

        var date = new Date(2000, 6, 1);
        var resultDate = new Date(2000, 5, 1);

        var calendar = configureCalendar(date, views.Month);
        dv.focusedValue = new Date(date);

        dv.open(position);

        dv.navigate({ keyCode: 37, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.viewedMonth.toDate() - resultDate, 0, 'does not navigate to the past month');
    });


    test('if datepicker focused ctrl and left arrow should navigate to passed year', function () {
        var date = new Date(2000, 6, 1);
        var resultDate = new Date(1999, 6, 1);

        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Year);

        dv.navigate({ keyCode: 37, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.viewedMonth.toDate() - resultDate, 0, 'does not navigate to the past year');
    });

    test('if datepicker focused ctrl and left arrow should navigate to passed decade', function () {

        var date = new Date(2000, 6, 1);
        var resultDate = new Date(1990, 6, 1);

        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Decade);

        dv.navigate({ keyCode: 37, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.viewedMonth.toDate() - resultDate, 0, 'does not navigate to the past decade');
    });


    test('if datepicker focused ctrl and left arrow should navigate to passed century', function () {

        var date = new Date(2000, 6, 1);
        var resultDate = new Date(1900, 6, 1);

        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Century);

        dv.navigate({ keyCode: 37, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.viewedMonth.toDate() - resultDate, 0, 'does not navigate to the past century');
    });


    test('if datepicker focused ctrl and right arrow should navigate to future month', function () {

        var date = new Date(2000, 6, 1);
        var resultDate = new Date(2000, 7, 1);

        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 39, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.viewedMonth.toDate() - resultDate, 0, 'does not navigate to the past century');
    });

    test('if datepicker focused ctrl and right arrow should navigate to passed year', function () {

        var date = new Date(2000, 6, 1);
        var resultDate = new Date(2001, 6, 1);

        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Year);

        dv.navigate({ keyCode: 39, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.viewedMonth.toDate() - resultDate, 0, 'does not navigate to the past century');
    });

    test('if datepicker focused ctrl and right arrow should navigate to passed decade', function () {

        var date = new Date(2000, 6, 1);
        var resultDate = new Date(2010, 6, 1);

        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Decade);

        dv.navigate({ keyCode: 39, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.viewedMonth.toDate() - resultDate, 0, 'does not navigate to the past century');
    });

    test('if datepicker focused ctrl and right arrow should navigate to passed century', function () {

        var date = new Date(1999, 6, 1);
        var resultDate = new Date(2099, 6, 1);

        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Century);

        dv.navigate({ keyCode: 39, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.viewedMonth.toDate() - resultDate, 0, 'does not navigate to the past century');
    });

    test('if datepicker focused ctrl and down arrow change centuryView to decadeView', function () {

        var date = new Date(2000, 6, 1);

        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Century);

        dv.navigate({ keyCode: 40, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.currentView.index, views.Decade, 'currentView is not Decade');
    });

    test('if datepicker focused ctrl and down arrow change decadeView to yearView', function () {

        var date = new Date(2000, 6, 1);

        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Decade);

        dv.navigate({ keyCode: 40, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.currentView.index, views.Year, 'currentView is not Year');
    });

    test('if datepicker focused ctrl and up arrow change view to wider range', function () {

        var date = new Date(2000, 6, 1);
        dv.focusedValue = new Date(date);

        dv.open(position);

        var calendar = configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 38, ctrlKey: true, preventDefault: function () { } });

        equal(calendar.currentView.index, views.Year, 'currentView is not Year');
    });

    test('left key should focus previous date', function () {
        var date = new Date(2000, 10, 10);
        dv.focusedValue = new Date(date);

        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 37, preventDefault: function () { } });

        var $element = $('.t-state-focus', dv.$calendar);

        equal($element.find('.t-link').html(), '9', 'focused date is not correct');
        equal(dv.focusedValue.getDate(), 9);
    });

    test('right key should focus next date', function () {

        var date = new Date(2000, 10, 10);

        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 39, preventDefault: function () { } });

        var $element = $('.t-state-focus', dv.$calendar);

        equal($element.find('.t-link').html(), '11', 'focused date is not correct');
        equal(dv.focusedValue.getDate(), 11);
    });

    test('down key should focus next week day', function () {

        var date = new Date(2000, 10, 10);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 40, preventDefault: function () { } });

        var $element = $('.t-state-focus', dv.$calendar);

        equal($element.find('.t-link').html(), '17', 'focused date is not correct');
        equal(dv.focusedValue.getDate(), 17);
    });

    test('up key should focus previous week day', function () {

        var date = new Date(2000, 10, 10);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 38, preventDefault: function () { } });

        var $element = $('.t-state-focus', dv.$calendar);

        equal($element.find('.t-link').html(), '3', 'focused date is not correct');
        equal(dv.focusedValue.getDate(), 3);
    });

    test('left key should navigate to prev month day', function () {
        var date = new Date(2000, 10, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 37, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 9, 'month is not correct');
        equal(dv.focusedValue.getDate(), 31, 'day is not correct');
    });

    test('right key should navigate to next month day', function () {
        var date = new Date(2000, 10, 30);

        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 39, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 11, 'month is not correct');
        equal(dv.focusedValue.getDate(), 1, 'day is not correct');
    });

    test('up key should navigate to prev week and navigate', function () {
        var date = new Date(2000, 10, 4);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 38, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 9, 'month is not correct');
        equal(dv.focusedValue.getDate(), 28, 'day is not correct');
    });

    test('down key should navigate to next week and navigate', function () {

        var date = new Date(2000, 10, 28);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 40, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 11, 'month is not correct');
        equal(dv.focusedValue.getDate(), 5, 'day is not correct');
    });

    test('left key should navigate to prev month', function () {
        var date = new Date(2000, 10, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 37, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 9, 'month is not correct');
    });

    test('right key should navigate to next month', function () {
        var date = new Date(2000, 10, 31);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Month);

        dv.navigate({ keyCode: 39, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 11, 'month is not correct');
    });

    test('up key should focus july', function () {
        var date = new Date(2000, 10, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Year);

        dv.navigate({ keyCode: 38, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 6, 'month is not correct');
    });

    test('down key should focus november', function () {

        var date = new Date(2000, 6, 28);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Year);

        dv.navigate({ keyCode: 40, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 10, 'month is not correct');
    });

    test('up key should focus prev november', function () {
        var date = new Date(2000, 2, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Year);

        dv.navigate({ keyCode: 38, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 10, 'month is not correct');
        equal(dv.focusedValue.getFullYear(), 1999, 'year is not correct');
    });

    test('down key should focus next march', function () {

        var date = new Date(2000, 10, 28);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Year);

        dv.navigate({ keyCode: 40, preventDefault: function () { } });

        equal(dv.focusedValue.getMonth(), 2, 'month is not correct');
        equal(dv.focusedValue.getFullYear(), 2001, 'year is not correct');
    });

    test('left key should navigate to prev year', function () {
        var date = new Date(2000, 10, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Decade);

        dv.navigate({ keyCode: 37, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 1999, 'year is not correct');
    });

    test('right key should navigate to next year', function () {
        var date = new Date(2000, 10, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Decade);

        dv.navigate({ keyCode: 39, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 2001, 'year is not correct');
    });

    test('up key should focus 2000', function () {
        var date = new Date(2004, 10, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Decade);

        dv.navigate({ keyCode: 38, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 2000, 'year is not correct');
    });

    test('down key should focus 2004', function () {

        var date = new Date(2000, 6, 28);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Decade);

        dv.navigate({ keyCode: 40, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 2004, 'year is not correct');
    });

    test('up key should focus prev 1996', function () {
        var date = new Date(2000, 2, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Decade);

        dv.navigate({ keyCode: 38, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 1996, 'year is not correct');
    });

    test('down key should focus next 2014', function () {

        var date = new Date(2010, 10, 28);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Decade);

        dv.navigate({ keyCode: 40, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 2014, 'year is not correct');
    });

    test('left key should navigate to prev decade', function () {
        var date = new Date(2000, 10, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Century);

        dv.navigate({ keyCode: 37, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 1990, 'year is not correct');
    });

    test('right key should navigate to next decade', function () {
        var date = new Date(2000, 10, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Century);

        dv.navigate({ keyCode: 39, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 2010, 'year is not correct');
    });

    test('up key should focus 2004 in century view', function () {
        var date = new Date(2044, 10, 1);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Century);

        dv.navigate({ keyCode: 38, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 2004, 'year is not correct');
    });

    test('down key should focus 2044', function () {

        var date = new Date(2004, 6, 28);
        dv.focusedValue = new Date(date);
        dv.open(position);

        configureCalendar(date, views.Century);

        dv.navigate({ keyCode: 40, preventDefault: function () { } });

        equal(dv.focusedValue.getFullYear(), 2044, 'year is not correct');
    });

    test('enter key should call onChage callback if view is month', function () {
        var isCalled = false;

        dv.onChange = function (value) { isCalled = true; }
        dv.open(position);

        dv.navigate({ keyCode: 13, preventDefault: function () { }, stopPropagation: function () { } });

        ok(isCalled);
    });

</script>

</asp:Content>
