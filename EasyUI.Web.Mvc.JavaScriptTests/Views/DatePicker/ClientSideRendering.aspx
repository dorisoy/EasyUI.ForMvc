<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
     <input id="DatePickerInput" />

     <input id="DatePickerWithValue" value="10/10/2000"/>

     <% Html.EasyUI().ScriptRegistrar().DefaultGroup(group => group.Add("easyui.common.js")
                                                                   .Add("easyui.datepicker.js")
                                                                   .Add("easyui.calendar.js")); %>
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        module("DatePicker / ClientSideRendering", {
            setup: function () {
                $('#DatePickerInput').tDatePicker();
            }
        });

        test('element property should be DIV wrapper', function () {
            var element = $('#DatePickerInput').data('tDatePicker').$wrapper[0];
            equal(element.nodeName, 'DIV', 'wrapper is not created');
            equal(element.className, 't-widget t-datepicker', 'wrapper is not created');
        });

        test('input should have t-input class', function () {
            ok($('#DatePickerInput').hasClass('t-input'), 't-input class was not added');
        });

        test('popup button should be rendered if showButton is true', function () {
            var $wrapper = $('#DatePickerInput').closest('.t-datepicker');
            ok($wrapper.find('.t-icon-calendar').length > 0, 'show popup button was not rendeted');
            equal($wrapper.find('.t-icon-calendar').attr('title'), $.fn.tDatePicker.defaults.buttonTitle, 'button title is not set correctly');
        });

        test('call _value method if input has an value', function () {
            var date = new Date(2000, 9, 10);

            var $input = $('#DatePickerWithValue');
            $input.val('10/10/2000');

            $input.tDatePicker();

            var selectedValue = $input.data('tDatePicker').value();

            equal(selectedValue.getFullYear(), date.getFullYear(), 'year is not correct');
            equal(selectedValue.getMonth(), date.getMonth(), 'month is not correct');
            equal(selectedValue.getDate(), date.getDate(), 'day is not correct');
        })

    </script>    

</asp:Content>