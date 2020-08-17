<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% Html.EasyUI().ScriptRegistrar()
           .Scripts(scripts => scripts
               .Add("easyui.common.js")
               .Add("easyui.calendar.js")); %>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
    var calendarObject;

    module("Calendar / Navigation", {
        setup: function () {
            calendarObject =
                    $($.easyui.calendar.html(new $t.datetime(), new $t.datetime()))
                        .appendTo(document.body)
                        .tCalendar()
                        .data('tCalendar');

            calendarObject.stopAnimation = true;
        },
        teardown: function () {
            $(calendarObject.element).remove();
            calendarObject = null;
        }
    });

    test('goToView updates viewedMonth', function () {
        calendarObject.goToView(0, new Date(2010, 3, 1));

        equal(calendarObject.viewedMonth.year(), 2010);
        equal(calendarObject.viewedMonth.month(), 3);
    });

    test('getFirstVisibleDay honors DST', function () {

        // 28. March will be skipped if the DST isn't honored
        ok(28 == $t.datetime.firstVisibleDay(new $t.datetime(2010, 3, 1)).date());
    });

    test('buildDateRows honors DST', function () {

        // DST on october 2009 will produce the 25th twice, if calcluations are wrong
        var html = $.easyui.calendar.views[0].body(new $t.datetime(2009, 9, 26),
                                                        new $t.datetime(calendarObject.minDate),
                                                        new $t.datetime(calendarObject.maxDate),
                                                        new $t.datetime(2009, 9, 26));

        var temporaryDom =
                $(html)
                    .appendTo(document.body)
                    .find('.t-link')
                    .filter(function () {
                        return parseInt($(this).text(), 10) == 25;
                    });

        ok(temporaryDom.length == 1);

        temporaryDom.remove();
    });

    test('buildDateRows should render days without links if they are out of range', function () {
        var html = $.easyui.calendar.views[0].body(new $t.datetime(2009, 9, 26),
                                                        new $t.datetime(2009, 9, 10),
                                                        new $t.datetime(2009, 9, 30),
                                                        new $t.datetime(2009, 9, 26));

        var renderedDays = $('.t-link', html).length;

        ok(renderedDays == 21);
    });

    test('buildDateRows should render days with URL to Action if dates are in the current month', function () {

        var html = $.easyui.calendar.views[0].body(new $t.datetime(2009, 9, 26),
                                                        new $t.datetime(2009, 9, 10),
                                                        new $t.datetime(2009, 9, 30),
                                                        new $t.datetime(2009, 9, 26),
                                                        '/aspnet-mvc-beta/calendar/selectaction?date={0}',
                                                        { '2009': { '9': [15, 21, 22]} });

        var renderedDays = $('.t-link', html).filter(function (index) {
            return $(this).attr('href').indexOf('selectaction') != -1;
        })
        ok(renderedDays.length == 3)
    });

    test('buildDateRows should render all days with Url to Action if no dates passed', function () {
        var html = $.easyui.calendar.views[0].body(new $t.datetime(2009, 9, 26),
                                                        new $t.datetime(2009, 9, 10),
                                                        new $t.datetime(2009, 9, 30),
                                                        new $t.datetime(2009, 9, 26),
                                                        '/aspnet-mvc-beta/calendar/selectaction?date={0}');
        var renderedDays = $('.t-link', html);

        var days_with_URL = renderedDays.filter(function (index) {
            return $(this).attr('href') != '#';
        })

        ok(renderedDays.length == days_with_URL.length)
    });

    test('buildDateRows should render all days with Url and t action link class', function () {
        var html = $.easyui.calendar.views[0].body(new $t.datetime(2009, 9, 26),
                                                        new $t.datetime(2009, 9, 10),
                                                        new $t.datetime(2009, 9, 30),
                                                        new $t.datetime(2009, 9, 26),
                                                        '/aspnet-mvc-beta/calendar/selectaction?date={0}');

        var days_with_URL = $('.t-link', html).filter(function (index) {
            return $(this).attr('href') != '#';
        })

        ok($(days_with_URL[0]).hasClass('t-action-link'))
    });

    test('buildDateRows should render title attribute', function () {
        var html = $.easyui.calendar.views[0].body(new $t.datetime(2009, 9, 26),
                                                        new $t.datetime(2009, 9, 10),
                                                        new $t.datetime(2009, 9, 30),
                                                        new $t.datetime(2009, 9, 26),
                                                        '/aspnet-mvc-beta/calendar/selectaction?date={0}');

        var days_with_title = $('.t-link', html).filter(function (index) {

            return $(this).attr('title') == '';
        })

        equal(days_with_title.length, 0);
    });

    test('Rendering of week headers should depend on firstDayOfWeek', function () {
        $.easyui.cultureInfo.firstDayOfWeek = 2; //Tuesday
        var html = $.easyui.calendar.views[0].body(new $t.datetime(2009, 9, 26),
                                                        new $t.datetime(2009, 9, 10),
                                                        new $t.datetime(2009, 9, 30),
                                                        new $t.datetime(2009, 9, 26),
                                                        '/aspnet-mvc-beta/calendar/selectaction?date={0}');

        var firsDayOfWeek = $(html).find('th').eq(0);

        equal(firsDayOfWeek.html(), "Tu", "FirstDayOfWeek is not get into account");
        equal(firsDayOfWeek.attr('title'), "Tuesday", "FirstDayOfWeek is not get into account");

        $.easyui.cultureInfo.firstDayOfWeek = 0; //Tuesday
    });

    test('Rendering of week headers should be 7 and start with FirstDayOfWeek', function () {
        $.easyui.cultureInfo.firstDayOfWeek = 2; //Tuesday
        var html = $.easyui.calendar.views[0].body(new $t.datetime(2009, 9, 26),
                                                        new $t.datetime(2009, 9, 10),
                                                        new $t.datetime(2009, 9, 30),
                                                        new $t.datetime(2009, 9, 26),
                                                        '/aspnet-mvc-beta/calendar/selectaction?date={0}');

        var weekHeaders = $(html).find('th');

        equal(weekHeaders.length, 7, "not wall day headers of the week are rendered");
        equal(weekHeaders.eq(5).attr('title'), "Sunday", "cultureInfo.days are not concat correctly");

        $.easyui.cultureInfo.firstDayOfWeek = 0; //Tuesday
    });

    test('if focusedDate has same month as min date prev arrow should be disabled', function () {

        calendarObject.minDate = new Date(2009, 9, 10);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.goToView(0, new Date(2009, 9, 1));

        ok($('.t-nav-prev', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if focusedDate has same month as min date prev arrow should be disabled year view', function () {

        calendarObject.minDate = new Date(2009, 9, 10);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.goToView(1, new Date(2009, 9, 1));

        ok($('.t-nav-prev', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if focusedDate has same month as min date prev arrow should be disabled decade view', function () {

        calendarObject.minDate = new Date(2009, 9, 10);
        calendarObject.selectedDate = Date(2009, 9, 11);
        calendarObject.goToView(2, new Date(2009, 9, 1));

        ok($('.t-nav-prev', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if focusedDate has same month as min date prev arrow should be disabled century view', function () {

        calendarObject.minDate = new Date(2009, 9, 10);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.goToView(3, new Date(2009, 9, 1));

        ok($('.t-nav-prev', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if focusedDate has same month as max date next arrow should be disabled', function () {

        calendarObject.maxDate = new Date(2009, 9, 30);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.goToView(0, new Date(2009, 9, 1));

        ok($('.t-nav-next', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if focusedDate has same month as max date next arrow should be disabled year view', function () {

        calendarObject.maxDate = new Date(2009, 9, 30);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.goToView(1, new Date(2009, 9, 1));

        ok($('.t-nav-next', calendarObject.element).hasClass('t-state-disabled'));
    });
    test('if focusedDate has same month as max date next arrow should be disabled decade view', function () {

        calendarObject.maxDate = new Date(2009, 9, 30);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.goToView(2, new Date(2009, 9, 1));

        ok($('.t-nav-next', calendarObject.element).hasClass('t-state-disabled'));
    });
    test('if focusedDate has same month as max date next arrow should be disabled century view', function () {

        calendarObject.maxDate = new Date(2009, 9, 30);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.goToView(3, new Date(2009, 9, 1));

        ok($('.t-nav-next', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if viewMonth has same month as min date prev arrow should be disabled', function () {

        calendarObject.minDate = new Date(2009, 9, 10);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.navigateVertically(0, new Date(2009, 9, 1), false, $('<a class="t-link"></a>'));

        ok($('.t-nav-prev', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if viewMonth has same month as min date prev arrow should be disabled year view', function () {

        calendarObject.minDate = new Date(2009, 9, 10);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.navigateVertically(1, new Date(2009, 9, 1), false, $('<a class="t-link"></a>'));

        ok($('.t-nav-prev', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if viewMonth has same month as min date prev arrow should be disabled decade view', function () {

        calendarObject.minDate = new Date(2009, 9, 10);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.navigateVertically(2, new Date(2009, 9, 1), false, $('<a class="t-link"></a>'));

        ok($('.t-nav-prev', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if viewMonth has same month as min date prev arrow should be disabled century view', function () {

        calendarObject.minDate = new Date(2009, 9, 10);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.navigateVertically(3, new Date(2009, 9, 1), false, $('<a class="t-link"></a>'));

        ok($('.t-nav-prev', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if viewMonth has same month as max date next arrow should be disabled', function () {
        calendarObject.maxDate = new Date(2009, 9, 30);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.navigateVertically(0, new Date(2009, 9, 1), false, $('<a class="t-link"></a>'));

        ok($('.t-nav-next', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if viewMonth has same month as max date next arrow should be disabled year view', function () {

        calendarObject.maxDate = new Date(2009, 9, 30);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.navigateVertically(1, new Date(2009, 9, 1), false, $('<a class="t-link"></a>'));

        ok($('.t-nav-next', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if viewMonth has same month as max date next arrow should be disabled decade view', function () {

        calendarObject.maxDate = new Date(2009, 9, 30);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.navigateVertically(2, new Date(2009, 9, 1), false, $('<a class="t-link"></a>'));

        ok($('.t-nav-next', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('if viewMonth has same month as max date next arrow should be disabled century view', function () {

        calendarObject.maxDate = new Date(2009, 9, 30);
        calendarObject.selectedDate = new Date(2009, 9, 11);
        calendarObject.navigateVertically(3, new Date(2009, 9, 1), false, $('<a class="t-link"></a>'));

        ok($('.t-nav-next', calendarObject.element).hasClass('t-state-disabled'));
    });

    test('selected date should render with selected state', function () {
        var html = $.easyui.calendar.views[0].body(new $t.datetime(2009, 9, 26),
                                                        new $t.datetime(calendarObject.minDate),
                                                        new $t.datetime(calendarObject.maxDate),
                                                        new $t.datetime(2009, 9, 26));

        ok($(html).find('.t-state-selected').length == 1);
    });

    test('date selection within current month sets selected date correctly', function () {
        calendarObject.goToView(0, new Date(2009, 10, 26));

        $(calendarObject.element).find('.t-content td:not(.t-other-month) .t-link').filter(function () {
            return $(this).text() == '3';
        }).eq(0).trigger('click');

        var selectedDate = new $t.datetime(calendarObject.selectedDate);

        equal(selectedDate.year(), 2009);
        equal(selectedDate.month(), 10);
        equal(selectedDate.date(), 3);
    });

    test('date selection within previous month sets selected date correctly', function () {
        calendarObject.goToView(0, new Date(2009, 10, 26));

        $(calendarObject.element).find('.t-content td.t-other-month .t-link').filter(function () {
            return $(this).text() == '29';
        }).eq(0).trigger('click');

        var selectedDate = new $t.datetime(calendarObject.selectedDate);

        equal(selectedDate.year(), 2009);
        equal(selectedDate.month(), 9);
        equal(selectedDate.date(), 29);
    });

    test('date selection within next month sets selected date correctly', function () {
        calendarObject.goToView(0, new Date(2009, 10, 26));

        $(calendarObject.element).find('.t-content td.t-other-month .t-link').filter(function () {
            return $(this).text() == '1';
        }).eq(0).trigger('click');

        var selectedDate = new $t.datetime(calendarObject.selectedDate);

        equal(selectedDate.year(), 2009);
        equal(selectedDate.month(), 11);
        equal(selectedDate.date(), 1);
    });

    test('date selection within next month of next year sets selected date correctly', function () {
        calendarObject.goToView(0, new Date(2009, 11, 26));

        $(calendarObject.element).find('.t-content td.t-other-month .t-link').filter(function () {
            return $(this).text() == '1';
        }).eq(0).trigger('click');

        var selectedDate = new $t.datetime(calendarObject.selectedDate);

        equal(selectedDate.year(), 2010);
        equal(selectedDate.month(), 0);
        equal(selectedDate.date(), 1);
    });

    test('date selection within previous month of previous year sets selected date correctly', function () {
        calendarObject.goToView(0, new Date(2009, 0, 1));

        $(calendarObject.element).find('.t-content td.t-other-month .t-link').filter(function () {
            return $(this).text() == '29';
        }).eq(0).trigger('click');

        var selectedDate = new $t.datetime(calendarObject.selectedDate);

        equal(selectedDate.year(), 2008);
        equal(selectedDate.month(), 11);
        equal(selectedDate.date(), 29);
    });

    test('date selection does not overflow when selecting previous month', function () {
        calendarObject.goToView(0, new Date(2010, 1, 1));

        $(calendarObject.element).find('.t-content td.t-other-month .t-link').filter(function () {
            return $(this).text() == '31';
        }).eq(0).trigger('click');

        var selectedDate = new $t.datetime(calendarObject.selectedDate);

        equal(selectedDate.year(), 2010);
        equal(selectedDate.month(), 0);
        equal(selectedDate.date(), 31);
    });

    test('date selection does not change selected date when cancelled', function () {
        calendarObject.value(new $t.datetime(1987, 3, 21));

        $(calendarObject.element).bind('change', function (e) {
            e.preventDefault();
        });

        $(calendarObject.element).find('.t-content td .t-link').filter(function () {
            return $(this).text() == '22';
        }).eq(0).trigger('click');

        var selectedDate = new $t.datetime(calendarObject.selectedDate);

        equal(selectedDate.year(), 1987);
        equal(selectedDate.month(), 3);
        equal(selectedDate.date(), 21);
    });
    test('date less than min date should not be rendered', function () {

        var minDate = new $t.datetime(2000, 1, 1);

        var html = $.easyui.calendar.views[0].body(new $t.datetime(1999, 9, 26),
                                                        minDate,
                                                        new $t.datetime(calendarObject.maxDate),
                                                        new $t.datetime(2009, 9, 26));

        ok($(html).find('> .t-link').length == 0);
    });

    test('date bigger than max date should not be rendered', function () {

        var maxDate = new $t.datetime(2010, 1, 1);

        var html = $.easyui.calendar.views[0].body(new $t.datetime(2019, 9, 26),
                                                        new $t.datetime(calendarObject.minDate),
                                                        maxDate,
                                                        new $t.datetime(2009, 9, 26));

        ok($(html).find('> .t-link').length == 0);
    });


    test('goToView with date with same month as maxdate should disable rightArrow', function () {

        calendarObject.maxDate = new Date(2000, 2, 30);
        calendarObject.selectedDate = new Date(2000, 2, 23);

        calendarObject.goToView(0, $t.datetime.firstDayOfMonth(new $t.datetime(2000, 2, 24)).toDate());

        ok($(calendarObject.element).find('.t-nav-next').hasClass('t-state-disabled'));
    });

    test('buildYearView should not render months less than min date', function () {
        var html = $.easyui.calendar.views[1].body(new $t.datetime(2009, 9, 1), new $t.datetime(2009, 9, 10), new $t.datetime(calendarObject.maxDate));

        ok($('.t-link', html).length == 3);
    });

    test('buildYearView should not render months bigger than max date', function () {
        var html = $.easyui.calendar.views[1].body(new $t.datetime(2009, 9, 1), new $t.datetime(calendarObject.minDate), new $t.datetime(2009, 9, 10));

        ok($('.t-link', html).length == 10);
    });

    test('buildDecadeView should not render months less than min date', function () {

        var html = $.easyui.calendar.views[2].body(new $t.datetime(2005, 9, 1), new $t.datetime(2002, 9, 10), new $t.datetime(calendarObject.maxDate));

        ok($('.t-link', html).length == 9);
    });

    test('buildDecadeView should not render months bigger than max date', function () {

        var html = $.easyui.calendar.views[2].body(new $t.datetime(2005, 9, 1), new $t.datetime(calendarObject.minDate), new $t.datetime(2008, 9, 10));

        ok($('.t-link', html).length == 10);
    });

    test('buildCenturyView should not render months less than min date', function () {

        var html = $.easyui.calendar.views[3].body(new $t.datetime(2005, 9, 1), new $t.datetime(2002, 9, 10), new $t.datetime(calendarObject.maxDate));

        ok($('.t-link', html).length == 11);
    });

    test('buildCenturyView should not render months bigger than max date', function () {

        var html = $.easyui.calendar.views[3].body(new $t.datetime(2005, 9, 1), new $t.datetime(calendarObject.minDate), new $t.datetime(2008, 9, 10));

        ok($('.t-link', html).length == 2);
    });

    test("Month's navCheck should return false if date1 and date2 had equal date part and isBigger is false", function () {
        var IsBigger = false;
        var date1 = new $.easyui.datetime(2010, 1, 1, 10, 10, 10);
        var date2 = new $.easyui.datetime(2010, 1, 1, 20, 10, 10);
        ok(!$.easyui.calendar.views[0].navCheck(date1, date2, IsBigger))
    });

    test("Month's navCheck should return false if date1=end of the month and the date2=is first day of the month. IsBigger is true", function () {
        var IsBigger = true;
        var date1 = new $.easyui.datetime(2010, 0, 31, 10, 10, 10);
        var date2 = new $.easyui.datetime(2010, 0, 1, 20, 10, 10);
        ok(!$.easyui.calendar.views[0].navCheck(date1, date2, IsBigger))
    });

    test("Month's navCheck should return true if date1 is 01/02/2010 and the date2=01/02/2010. IsBigger is true", function () {
        var IsBigger = true;
        var date1 = new $.easyui.datetime(2010, 1, 1, 10, 10, 10);
        var date2 = new $.easyui.datetime(2010, 0, 1, 20, 10, 10);
        ok($.easyui.calendar.views[0].navCheck(date1, date2, IsBigger))
    });

</script>

</asp:Content>