<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

      <%= Html.EasyUI().DatePicker()
              .Name("DatePicker")
              .Effects(e => e.Toggle())
      %>

        <%= Html.EasyUI().DatePicker()
            .Name("DatePicker1")
            .Effects(e => e.Toggle())
      %>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        function getDatePicker() {
            return $('#DatePicker').data('tDatePicker');
        }


        test('disable method should disable input', function () {
            var datepicker = getDatePicker();

            datepicker.enable();
            datepicker.disable();

            ok($('#DatePicker').attr('disabled'));
        });

        test('disable method should unbind click event of toggle button', function () {
            var datepicker = getDatePicker();

            datepicker.enable();
            datepicker.disable();

            var $icon = $('#DatePicker').closest('.t-datepicker').find('.t-icon');
            equal($icon.data('events').click.toString().indexOf('e.preventDefault();'), -1);
        });

        test('enable method should enable input', function () {
            var datepicker = getDatePicker();

            datepicker.disable();
            datepicker.enable();

            ok(!$('#DatePicker').attr('disabled'));
        });

        test('enable method should bind click event of toggle button', function () {
            var datepicker = getDatePicker();

            datepicker.disable();
            datepicker.enable();

            var $icon = $('#DatePicker').closest('.t-datepicker').find('.t-icon');

            ok(null !== $icon.data('events').click);
        });

        test('disable method should add state disabled', function () {
            var datepicker = getDatePicker();
            
            datepicker.enable();
            datepicker.disable();

            ok($('#DatePicker').closest('.t-datepicker').hasClass('t-state-disabled'));
        });

        test('enable method should remove state disabled', function () {
            var datepicker = getDatePicker();

            datepicker.disable();
            datepicker.enable();

            ok(!$('#DatePicker').closest('.t-datepicker').hasClass('t-state-disabled'));
        });

        test('open method should call dateView open method', function () {

            var datepicker = getDatePicker();
            var $element = datepicker.$element;

            var position = {
                offset: $element.offset(),
                outerHeight: $element.outerHeight(),
                outerWidth: $element.outerWidth(),
                zIndex: $.easyui.getElementZIndex($element[0])
            }

            var passedPos;

            var oldM = datepicker.dateView.open;
            datepicker.dateView.open = function (posisiton) { passedPos = posisiton; }

            datepicker.open();

            ok(undefined !== passedPos);
            equal(passedPos.offset.top, position.offset.top);
            equal(passedPos.offset.left, position.offset.left);
            equal(passedPos.elemHeight, position.elemHeight);
            equal(passedPos.outerWidth, position.outerWidth);
            equal(passedPos.zIndex, position.zIndex);

            datepicker.dateView.open = oldM;
        });

        test('close should close dateView', function () {
            var datepicker = getDatePicker();

            datepicker.open();
            datepicker.close();

            ok(!datepicker.dateView.isOpened());
        });

        test('value method should set selectedValue of the component', function () {
            var datepicker = getDatePicker();

            datepicker.value("10/10/2000");

            var selectedValue = new $.easyui.datetime(datepicker.selectedValue);

            equal(selectedValue.year(), 2000, 'year');
            equal(selectedValue.month(), 9, 'month');
            equal(selectedValue.date(), 10, 'day');
        });

        test('value method should call dateView value method', function () {
            var isCalled = false;
            var datepicker = getDatePicker();
            var oldM = datepicker.dateView.value;

            datepicker.dateView.value = function () { isCalled = true; }

            datepicker.value("");

            ok(isCalled);

            datepicker.dateView.value = oldM;
        });

        test('min method should set minDate property and call dateView min method', function () {
            var isCalled = false;
            var datepicker = getDatePicker();

            var oldM = datepicker.dateView.min;
            datepicker.dateView.min = function () { isCalled = true; }

            datepicker.min('10/10/1904');

            ok(isCalled);

            var minDate = new $.easyui.datetime(datepicker.minValue);

            equal(minDate.year(), 1904, 'year');
            equal(minDate.month(), 9, 'month');
            equal(minDate.date(), 10, 'day');

            datepicker.dateView.min = oldM;
        });

        test('min method should not set minValue if it is bigger then maxValue', function () {
            var datepicker = $('#DatePicker1').data('tDatePicker');
            var oldMin = datepicker.min();

            datepicker.max(new Date(1999, 10, 10));
            datepicker.min(new Date(2000, 10, 10));

            ok(oldMin - datepicker.min() == 0, "min date was incorrectly updated");
        });

        test('max method should not set maxValue if it is less then minValue', function () {
            var datepicker = $('#DatePicker1').data('tDatePicker');
            var oldMax = datepicker.max();

            datepicker.min(new Date(2000, 10, 10));
            datepicker.max(new Date(1999, 10, 10));

            ok(oldMax - datepicker.max() == 0, "min date was incorrectly updated");
        });

        test('value method with null should set empty text', function () {
            var datepicker = getDatePicker();
            var $element = datepicker.$element;

            datepicker.value(null);
            equal($element.val(), '');

            datepicker.value('');
            equal($element.val(), '');
        });

        test('value method with null when input has error class should set empty text', function () {
            var datepicker = getDatePicker();
            var $element = datepicker.$element;

            datepicker.value('11/31/2010');
            datepicker.value(null);

            equal($element.val(), '');

            datepicker.value('11/31/2010');
            datepicker.value('');

            equal($element.val(), '');
        });

        test('min method should return Date object of minDate', function () {
            var datepicker = getDatePicker();

            equal(datepicker.min() - datepicker.minValue, 0);
        });

</script>

</asp:Content>