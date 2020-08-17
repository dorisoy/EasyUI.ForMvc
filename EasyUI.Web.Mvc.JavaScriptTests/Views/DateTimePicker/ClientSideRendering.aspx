<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
     <input id="DateTimePicker" />

     <input id="DateTimePickerWithValue"/>

     <% Html.EasyUI().ScriptRegistrar()
            .DefaultGroup(group => group.Add("easyui.common.js")
            .Add("easyui.datetimepicker.js")
            .Add("easyui.datepicker.js")
            .Add("easyui.timepicker.js")
            .Add("easyui.calendar.js")); %>
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        module("DateTimePicker / ClientSideRendering", {
            setup: function () {
                $('#DateTimePicker').tDateTimePicker();
            }
        });

        test('element property should be DIV wrapper', function () {
            var element = $('#DateTimePicker').data('tDateTimePicker').$wrapper[0];
            equal(element.nodeName, 'DIV', 'wrapper is not created');
            equal(element.className, 't-widget t-datetimepicker', 'wrapper is not created');
        });

        test('input should have t-input class', function () {
            ok($('#DateTimePicker').hasClass('t-input'), 't-input class was not added');
        });
                
        test('calendar button should be rendered if showCalendarButton is true', function () {
            ok($('#DateTimePicker').closest('.t-datetimepicker').find('.t-icon-calendar').length > 0, 'calendar button was not rendeted');
            equal($('#DateTimePicker').closest('.t-datetimepicker').find('.t-icon-calendar').attr('title'), $.fn.tDateTimePicker.defaults.calendarButtonTitle, 'button title is not set correctly');
        });

        test('time button should be rendered if showTimeButton is true', function () {
            ok($('#DateTimePicker').closest('.t-datetimepicker').find('.t-icon-clock').length > 0, 'time button was not rendeted');
            equal($('#DateTimePicker').closest('.t-datetimepicker').find('.t-icon-clock').attr('title'), $.fn.tDateTimePicker.defaults.timeButtonTitle, 'button title is not set correctly');
        });

        test('call _value method if input has an value', function () {
            var date = new Date(2000, 9, 10, 10, 10, 0);

            var $input = $('#DateTimePickerWithValue');
            $input.val('10/10/2000 10:10 AM');

            $input.tDateTimePicker();

            var selectedValue = $input.data('tDateTimePicker').value();
            
            equal(selectedValue.getFullYear(), date.getFullYear(), 'year is not correct');
            equal(selectedValue.getMonth(), date.getMonth(), 'month is not correct');
            equal(selectedValue.getDate(), date.getDate(), 'day is not correct');
            equal(selectedValue.getHours(), date.getHours(), 'hours are not correct');
            equal(selectedValue.getMinutes(), date.getMinutes(), 'Minutes are not correct');
            equal(selectedValue.getSeconds(), date.getSeconds(), 'Seconds are not correct');
        })

    </script>    

</asp:Content>