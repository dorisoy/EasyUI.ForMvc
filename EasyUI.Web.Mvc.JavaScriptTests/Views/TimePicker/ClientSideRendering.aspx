<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
     <input id="TimePickerInput" />

     <input id="TimePickerWithValue"/>

     <% Html.EasyUI().ScriptRegistrar().DefaultGroup(group => group.Add("easyui.common.js")
                                                                   .Add("easyui.timepicker.js")); %>
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        module("TimePicker / ClientSideRendering", {
            setup: function () {
                $('#TimePickerInput').tTimePicker();
            }
        });

        test('element property should be DIV wrapper', function () {
            var wrapper = $('#TimePickerInput').data('tTimePicker').$wrapper[0];
            equal(wrapper.nodeName, 'DIV', 'wrapper is not created');
            equal(wrapper.className, 't-widget t-timepicker', 'wrapper is not created');
        });

        test('input should have t-input class', function () {
            ok($('#TimePickerInput').hasClass('t-input'), 't-input class was not added');
        });

        test('popup button should be rendered if showButton is true', function () {
            $wrapper = $('#TimePickerInput').data('tTimePicker').$wrapper;
            ok($wrapper.find('.t-icon-clock').length > 0, 'show popup button was not rendeted');
            equal($wrapper.find('.t-icon-clock').attr('title'), $.fn.tTimePicker.defaults.buttonTitle, 'button title is not set correctly');
        });

        test('call _value method if input has an value', function () {
            var $input = $('#TimePickerWithValue');
            $input.val('10:10');
            
            $input.tTimePicker();

            var selectedValue = $input.data('tTimePicker').value();

            equal(selectedValue.getHours(), '10', 'hours are not correct');
            equal(selectedValue.getMinutes(), '10', 'minutes are not correct');
        })

    </script>    

</asp:Content>