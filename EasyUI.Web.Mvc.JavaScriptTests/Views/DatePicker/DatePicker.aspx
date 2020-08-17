<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

     <%= Html.EasyUI().DatePicker().Name("DatePicker")
                       .Effects(e=>e.Toggle())
                       .Min(new DateTime(1600, 1, 1))
                       .Max(new DateTime(2400, 1, 1))
     %>

     <%= Html.EasyUI().DatePicker().Name("DatePicker2")
                       .Effects(e=>e.Toggle())
                       .Value(new DateTime(2000,10,10))
     %>

     <%= Html.EasyUI().DatePicker().Name("DatePickerWithInputAttr")
                .Effects(e=>e.Toggle())
                .InputHtmlAttributes(new {value = "12/12/2000"})
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

        function getDatePicker() {
            return $('#DatePicker').data('tDatePicker');
        }

        function isValidDate(year, month, day, date) {
            var isValid = true;

            if (year != date.getFullYear())
                isValid = false;
            else if (month != date.getMonth() + 1)
                isValid = false;
            else if (day != date.getDate())
                isValid = false;

            return isValid;
        }

        test('animation wrapper should be hidden on load', function () {
            ok($('.t-animation-container').is(':hidden'));
        });


        test('calendar with toggle animation should hide animation container', function () {
            getDatePicker().open();

            $(document.documentElement).mousedown();

            ok(!getDatePicker().dateView.isOpened());
        });

        test('parse date less than min date should return null', function () {
            var datepicker = getDatePicker()
            datepicker.format = "MM/dd/yyyy";

            datepicker.value("01/23/1400");
            ok(null === datepicker.selectedValue);
        });

        test('parse date bigger than min date should return null', function () {
            var datepicker = getDatePicker()
            datepicker.format = "MM/dd/yyyy";

            datepicker.value("01/23/2500");
            ok(null === datepicker.selectedValue);
        });

        test('parse date equal to min should parsed correctly', function () {
            var datepicker = getDatePicker()
            datepicker.format = "MM/dd/yyyy";

            datepicker.value("1/1/1900"); //in FF new Date(1899, 11, 31) == 1.1.1900
            ok(isValidDate(1900, 1, 1, datepicker.selectedValue));
        });

        test('parse date equal to max should parsed correctly', function () {

            var datepicker = getDatePicker()
            datepicker.format = "MM/dd/yyyy";

            datepicker.value("1/1/2100");
            ok(isValidDate(2100, 1, 1, datepicker.selectedValue));
        });

        test('if input value is bigger then maxValue blur event should change input value to maxValue', function () {
            var $input = $('#DatePicker');
            var datepicker = getDatePicker();

            datepicker._update('1/1/2410');

            equal(+datepicker.maxValue, +datepicker.parse($input.val()));
        });

        test('if input value is bigger then maxValue blur event should change remove error class', function () {
            var $input = $('#DatePicker');
            var datepicker = getDatePicker();

            datepicker._update('1/1/2410');
            
            ok(!$input.hasClass('t-state-error'));
        });

        test('if input value is smaller then minValue blur event should change input value to minValue', function () {
            var $input = $('#DatePicker');
            var datepicker = getDatePicker();

            datepicker._update('1/1/1500');

            equal(+datepicker.minValue, +datepicker.parse($input.val()));
        });

        test('if input value is smaller then minValue blur event should change remove error class', function () {
            var $input = $('#DatePicker');
            var datepicker = getDatePicker();

            datepicker._update('1/1/1500');

            ok(!$input.hasClass('t-state-error'));
        });

        test('datepicker should close internal methods if document mousedown', function () {
            var isCloseCalled = false;
            var datepicker = getDatePicker();

            var oldClose = datepicker._close;

            datepicker._close = function () { isCloseCalled = true; };

            datepicker.open();

            $(document.documentElement).trigger('mousedown');

            ok(isCloseCalled, '_close was not called');

            datepicker._close = oldClose;
        });

        test('dateView value should be called if input has value ot selectedValue is not null', function () {
            var datepicker = $('#DatePicker2').data('tDatePicker');
            datepicker.open();

            var day = datepicker.dateView.$calendar.find('.t-state-selected');

            equal('10', day.text(), 'not correct day is selected');
        });

        test('dateView value should be called if selectedValue is not null', function () {
            var datepicker = $('#DatePicker2').data('tDatePicker');
            datepicker.open();

            var day = datepicker.dateView.$calendar.find('.t-state-selected');

            equal('10', day.text(), 'not correct day is selected');
        });        
        
        test('dateView value should be called if input has value', function () {
            var datepicker = $('#DatePickerWithInputAttr').data('tDatePicker');
            datepicker.open();

            var day = datepicker.dateView.$calendar.find('.t-state-selected');

            equal('12', day.text(), 'not correct day is selected');
        });

        test('error class should be added on blur', function () {
            var datepicker = $('#DatePickerWithInputAttr').data('tDatePicker'),
                element = datepicker.$element;
            
            datepicker.close();   
            element.focus().val("wrong value").blur();
            
            setTimeout(function() {
                start();
                ok(element.hasClass('t-state-error'));
            }, 200);

            stop(300);
        });

    </script>

</asp:Content>