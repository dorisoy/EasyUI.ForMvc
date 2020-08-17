<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>Keyboard support</h2>
    
    <script type="text/javascript">

        function getTimePicker() {
            return $('#TimePicker').data('tTimePicker');
        }

    </script>
    
    <%= Html.EasyUI().TimePicker()
            .Name("TimePicker")
            .Value(new Nullable<DateTime>())
            .Effects(e => e.Toggle()) 
    %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        test('pressing alt down arrow should open dropdown list', function() {
            var timepicker = getTimePicker();
            timepicker.effects = $.easyui.fx.toggle.defaults();

            timepicker.close();
            timepicker.$element.focus();
            timepicker.$element.trigger({ type: "keydown", keyCode: 40, altKey: true });

            ok(timepicker.timeView.dropDown.isOpened());
        });

        test('pressing Enter should close dropdown list', function() {
            var isCalled = false;
            var timepicker = getTimePicker();

            timepicker.$element.focus();

            var old = timepicker.close;

            timepicker.close = function () { isCalled = true; }

            timepicker.$element.trigger({ type: "keydown", keyCode: 40 });
            timepicker.$element.trigger({ type: "keydown", keyCode: 13 });

            ok(isCalled);

            timepicker.close = old;
        });

        test('pressing escape should call close', function() {
            var isCalled = false;
            var timepicker = getTimePicker();
            timepicker.effects = timepicker.timeView.dropDown.effects = $.easyui.fx.toggle.defaults();

            timepicker.open();
            timepicker.$element.focus();
            var old = timepicker.close;

            timepicker.close = function () { isCalled = true; }

            timepicker.$element.trigger({ type: "keydown", keyCode: 27 });

            ok(isCalled);

            timepicker.close = old;
        });

</script>

</asp:Content>