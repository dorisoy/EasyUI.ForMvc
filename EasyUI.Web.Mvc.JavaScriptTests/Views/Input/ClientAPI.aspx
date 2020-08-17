<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

     <%= Html.EasyUI().NumericTextBox()
           .Name("numerictextbox")
     %>

     <%= Html.EasyUI().NumericTextBox()
             .Name("numerictextbox1")
             .MinValue(-1)
             .MaxValue(10)
     %>

    <script type="text/javascript">

        function getNumericTextBox(selector) {
            return $(selector || '#numerictextbox').data('tTextBox');
        }

    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        test('disable method should disable input', function() {
            var numericTextBox = getNumericTextBox();

            numericTextBox.enable();
            numericTextBox.disable();

            ok($('#numerictextbox').attr('disabled'));
        });

        test('disable method should unbind click event of toggle button', function() {
            var numericTextBox = getNumericTextBox();
            
            numericTextBox.enable();
            numericTextBox.disable();

            var $links = $('#numerictextbox').siblings().filter('.t-icon');

            ok(!($links.first().data('events').mousedown[0].handler !== $.easyui.preventDefault));
            ok(!($links.last().data('events').mousedown[0].handler !== $.easyui.preventDefault));
        });

        test('enable method should bind click event of toggle button', function() {
            var numericTextBox = getNumericTextBox();
                    
            numericTextBox.disable();
            numericTextBox.enable();

            var $links = $('#numerictextbox').siblings().filter('.t-icon');

            ok(undefined !== $links.first().data('events').mousedown);
            ok(undefined !== $links.last().data('events').mousedown);
        });

        test('disable method should add state disabled', function() {
            var numericTextBox = getNumericTextBox();
            numericTextBox.enable();
            numericTextBox.disable();

            ok(numericTextBox.$wrapper.hasClass('t-state-disabled'));
        });

        test('enable method should remove state disabled', function () {
            var numericTextBox = getNumericTextBox();
            numericTextBox.disable();
            numericTextBox.enable();
            
            ok(!numericTextBox.$wrapper.hasClass('t-state-disabled'));
        });

        test('enable method with zero value should not remove value', function() {
            var numericTextBox = getNumericTextBox();
            numericTextBox.value(0);
            numericTextBox.enable();

            equal(numericTextBox.value(), 0);
        });

        test('disable method should not remove value', function() {
            var numericTextBox = getNumericTextBox();
            numericTextBox.value(10);
            numericTextBox.disable();

            equal(numericTextBox.value(), 10);
        });  

        test('disable method should set empty value', function() {
            var numericTextBox = getNumericTextBox();
            numericTextBox.value('');
            numericTextBox.disable();

            equal(numericTextBox.value(), null);
        });

        test('value method should return null if value is not between minValue and maxValue', function() {
            var numericTextBox = getNumericTextBox('#numerictextbox1');
            numericTextBox.value(-2);
            equal(numericTextBox.value(), null);

            numericTextBox.value(11);
            equal(numericTextBox.value(), null);
        });

        test('value method should update input and span values', function () {
            var numericTextBox = getNumericTextBox();
            numericTextBox.value(5);

            equal(numericTextBox.$text.html(), '5.00');
            equal(numericTextBox.$element.val(), numericTextBox.value())
        });

        test('value method should set NULL if value is not correct number', function () {
            var numericTextBox = getNumericTextBox();
            numericTextBox.enabled = true;

            numericTextBox.value('wrong');

            equal(numericTextBox.$text.html(), numericTextBox.text);
            equal(numericTextBox.value(), null)
        });

        test('value method should not add empty text if component is disabled', function () {
            var numericTextBox = getNumericTextBox();
            numericTextBox.enabled = false;

            numericTextBox.value('wrong');

            equal(numericTextBox.$text.html(), '');
            equal(numericTextBox.value(), null)
        });

        test('value should round argument/parsed value', function () {
            var numericTextBox = getNumericTextBox();
            numericTextBox.digits = 2;

            numericTextBox.value('1.2222');
            equal(numericTextBox.value(), 1.22);
        });


        test('if value cannot be parsed (it is null) input value should be empty string.', function () {
            var numeric = getNumericTextBox();

            numeric.$element.val("#22");
            numeric.val = null;

            numeric._update(null);

            equal(numeric.$element.val(), "");
        });


        test('_modify should add argument to the current value and call value method', function () {
            var passedValue;
            var numericTextBox = getNumericTextBox();

            var oldvalue = numericTextBox._value;
            numericTextBox._value = function (value) { passedValue = value; }

            numericTextBox.$element.val(0);
            numericTextBox._modify(1);

            numericTextBox._value = oldvalue;

            equal(passedValue, 1);

        });

        test('_modify should put in range modified value (set min value)', function () {
            var numericTextBox = getNumericTextBox();
            var result;

            var oldUpdate = numericTextBox._update;
            var minValue = numericTextBox.minValue = -100;
            numericTextBox.$element.val(minValue);
            numericTextBox._update = function (value) { result = value; }

            
            numericTextBox._modify(-1);

            numericTextBox._update = oldUpdate;

            equal(result, minValue.toString());

        });
        
        test('_modify should put in range modified value (set max value)', function () {
            var numericTextBox = getNumericTextBox();

            var maxValue = numericTextBox.maxValue = 100;

            numericTextBox.value(maxValue);
            numericTextBox._modify(1);

            equal(numericTextBox.element.value, maxValue.toString());
        });

        test('_modify should fix parsed value', function () {
            var numericTextBox = getNumericTextBox();
            var oldUpdate = numericTextBox._update;
            var result;

            numericTextBox._update = function (value) { result = value; }

            numericTextBox.$element.val("10.2222");

            numericTextBox._modify(1);

            numericTextBox._update = oldUpdate;

            equal(result, 11.22);
        });

        test("parse method should return Number object from 100,55", function () {
            var numericTextBox = getNumericTextBox(),
                oldSeparator = numericTextBox.separator,
                oldReg = numericTextBox.replaceRegExp;

            numericTextBox.separator = ",";
            numericTextBox.replaceRegExp = new RegExp('[ |' + '.]', 'g');

            var result = numericTextBox.parse("100,55");

            equal(result, 100.55);

            numericTextBox.separator = oldSeparator;
            numericTextBox.replaceRegExp = oldReg;
        });
</script>

</asp:Content>