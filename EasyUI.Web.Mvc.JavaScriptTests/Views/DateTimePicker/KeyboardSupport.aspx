<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
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
            .Value(new Nullable<DateTime>())
            .Effects(e => e.Toggle())
    %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        test('pressing alt down arrow should open dateView if no view is opened', function() {
            var dateTimePicker = getDateTimePicker();
            dateTimePicker.effects = $.easyui.fx.toggle.defaults();

            dateTimePicker.$element.focus();
            dateTimePicker.close();
            dateTimePicker.$element.trigger({ type: "keydown", keyCode: 40, altKey: true });

            ok(dateTimePicker.dateView.isOpened());
        });

        test('pressing alt down arrow should open timeView and close dateView if dateView is already opened', function () {
            var dateTimePicker = getDateTimePicker();
            dateTimePicker.effects = $.easyui.fx.toggle.defaults();

            dateTimePicker.$element.focus();
            dateTimePicker.close();
            dateTimePicker.open('date');
            dateTimePicker.$element.trigger({ type: "keydown", keyCode: 40, altKey: true });

            ok(dateTimePicker.timeView.isOpened());
            ok(!dateTimePicker.dateView.isOpened());
        });

        test('pressing alt down arrow should open dateView and close timeView if timeView is already opened', function () {
            var dateTimePicker = getDateTimePicker();
            dateTimePicker.effects = $.easyui.fx.toggle.defaults();

            dateTimePicker.$element.focus();
            dateTimePicker.close();
            dateTimePicker.open('time');
            dateTimePicker.$element.trigger({ type: "keydown", keyCode: 40, altKey: true });

            ok(!dateTimePicker.timeView.isOpened());
            ok(dateTimePicker.dateView.isOpened());
        });

        test('pressing Enter should close dropdown list', function() {
            var isCalled = false;
            var dateTimePicker = getDateTimePicker();

            dateTimePicker.$element.focus();

            dateTimePicker.open('date');

            var old = dateTimePicker.close;

            dateTimePicker.close = function () { isCalled = true; }
            dateTimePicker.$element.trigger({ type: "keydown", keyCode: 13 });
            ok(isCalled);

            dateTimePicker.close = old;
        });

        test('pressing Enter should call _change method', function () {
            var isCalled = false;
            var dateTimePicker = getDateTimePicker();          

            dateTimePicker.close();
            dateTimePicker.open('date');
            dateTimePicker.$element.focus();
            dateTimePicker.open('date');
            var old = dateTimePicker._change;
            dateTimePicker.dateView.$calendar.data('tCalendar').stopAnimation = true;
            dateTimePicker._change = function () { isCalled = true; }

            dateTimePicker.$element.trigger({ type: "keydown", keyCode: 13 });

            dateTimePicker._change = old;
        });

        test('pressing escape should call close', function() {
            var isCalled = false;
            var dateTimePicker = getDateTimePicker();

            dateTimePicker.open();
            dateTimePicker.$element.focus();
            var old = dateTimePicker.close;

            dateTimePicker.close = function () { isCalled = true; }

            dateTimePicker.$element.trigger({ type: "keydown", keyCode: 27 });

            ok(isCalled);

            dateTimePicker.close = old;
        });

        test('if dateView is opened and no important key pressed should call navigate', function() {
            var isCalled = false;
            var dateTimePicker = getDateTimePicker();

            dateTimePicker.open('date');
            dateTimePicker.$element.focus();
            var old = dateTimePicker.dateView.navigate;

            dateTimePicker.dateView.navigate = function () { isCalled = true; }

            dateTimePicker.$element.trigger({ type: "keydown", keyCode: 40 });

            ok(isCalled);

            dateTimePicker.dateView.navigate = old;
        });

        test('if timeView is opened and no important key pressed should call navigate', function() {
            var isCalled = false;
            var dateTimePicker = getDateTimePicker();

            dateTimePicker.open('time');
            dateTimePicker.close('date');
            dateTimePicker.$element.focus();
            var old = dateTimePicker.timeView.navigate;

            dateTimePicker.timeView.navigate = function () { isCalled = true; }

            dateTimePicker.$element.trigger({ type: "keydown", keyCode: 40 });

            ok(isCalled);

            dateTimePicker.timeView.navigate = old;
        });

</script>

</asp:Content>
