<%@ Page Title="CollapseDelay Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        CollapseDelay Tests</h2>
     <label for="numerictextbox2">Click:</label>
     <%= Html.EasyUI().NumericTextBox()
             .Name("numerictextbox2")
             .MinValue(1)
             .MaxValue(80)
     %>
     <br />
     <%= Html.EasyUI().NumericTextBox()
           .Name("numerictextbox1")
           .MinValue(-10.2)
           .MaxValue(10000)
           .IncrementStep(1.44)
           .EmptyMessage("Enter text")
           %>
       <br />
     <%= Html.EasyUI().NumericTextBox()
           .Name("numerictextbox")
           .MinValue(-10)
           .EmptyMessage("Enter text") %> 
       <br />
     <%= Html.EasyUI().NumericTextBox()
           .Name("inputWithAttributes")
           .InputHtmlAttributes(new {
               maxlength = 3,
               style = "width: 40px",
               @readonly = "readonly",
               disabled = "disabled"
           }) %>

    <%= Html.EasyUI().NumericTextBox()
           .Name("DisabledNumeric")
           .Enable(false)
           .InputHtmlAttributes(new {
                @class="custom"
           }) %>
           <br />

    <%= Html.EasyUI().NumericTextBox()
           .Name("errorState") 
           .MaxValue(80)
    %>
     
    <script type="text/javascript">

        function getInput(selector) {
            return $(selector || "#numerictextbox").data("tTextBox");
        }

    </script>

<% Html.EasyUI().ScriptRegistrar().Globalization(true); %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    test("custom input CSS class should be copy to the DIV element which holds the formatted value", function () {
        var cssClass = getInput("#DisabledNumeric").$text.attr("class");
        
        equal(cssClass, "t-formatted-value custom t-state-empty");
    });

    test("custom input CSS class should be copy to the DIV element which holds the formatted value", function () {
        var textbox = getInput();

        equal(textbox.$element.attr("class"), "t-input");
        equal(textbox.$text.attr("class"), "t-formatted-value t-state-empty");
    });

    test('focusing input should make div invisible and input visible', function () {
        var textbox = getInput();

        textbox.$wrapper.focusin();

        ok(!textbox.$text.is(':visible'), 'div is still visible');
    });

    test('bluring input should make span visible and input invisible', function () {
        var textbox = getInput();

        textbox.$wrapper.focusout();

        ok(textbox.$text.is(':visible'), 'div is not visible');
    });
    
    test('input should not allow entering of char', function () {
        var which = "65"; //'a'
        var isDefaultPrevent = false;
        var $input = $('#numerictextbox');

        $input.trigger({ type: "keypress",
            keyCode: which,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
    });

    test('input should allow entering digit', function () {
        var keyCode = "48"; //'0'
        var isDefaultPrevent = false;
        var $input = $('#numerictextbox');
        $input.trigger({ type: "keypress",
            keyCode: keyCode,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });
        ok(!isDefaultPrevent);
    });

    test('input should not call _value method if element.value is not diff then this.val', function () {
        var $input = $('#numerictextbox');
        var input = $input.data("tTextBox");
        var called = false;
        var oldSetTimeout = window.setTimeout;
        var oldValue = input._value;

        try {
            window.setTimeout = function (callback, time) { callback(); }
            input.val = 0;
            input._value = function (val) { called = true; };
            $input.val("0.");

            $input.trigger({ type: "keypress",
                keyCode: 48
            });

            ok(!called);
        } finally {
            input._value = oldValue;
            window.setTimeout = oldSetTimeout;
        }
    });


    test('input should increase value with one step when up arrow keyboard is clicked', function () {
        var keyCode = "38";
        var $input = $('#numerictextbox');

        getInput().value(null);
        $input.val("");

        $input.trigger({ type: "keydown",
            keyCode: keyCode
        });

        equal(getInput().value(), 1);
    });

    test('input should decrease value with one step when down arrow keyboard is clicked', function () {
        var keyCode = "40";
        var $input = $('#numerictextbox');

        getInput().value(null);
        $input.val("");

        $input.trigger({ type: "keydown",
            keyCode: keyCode
        });

        equal(getInput().value(), -1);
    });


    test('input should increase value with one step when up arrow is clicked', function () {
        var $input = $('#numerictextbox');
        var $button = $input.siblings().filter('.t-arrow-up');

        getInput().value(null);
        $input.val("");

        $button.trigger({ type: "mousedown",
            which: 1
        });

        equal(getInput().value(), 1);
    });

    test('input should decrease value with one step when down arrow is clicked', function() {
        var $input = $('#numerictextbox');
        var $button = $input.siblings().filter('.t-arrow-down');

        getInput().value(null);
        $input.val("");

        $button.trigger({ type: "mousedown",
            which: 1
        });

        equal(getInput().value(), -1);
    });

    test('input should allow entering system keys', function() {
        var keyCode = "0"; //'system keys'
        var isDefaultPrevent = false;
        var $input = $('#numerictextbox');
        $input.trigger({ type: "keypress",
            keyCode: keyCode,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });
        ok(!isDefaultPrevent);
    });

    test('input should allow minus in first position', function() {
        var keyCode = 45;  // minus
        var isDefaultPrevent = false;

        var $input = $('#numerictextbox');

        $input.val('');
        $input.focus();

        $input.trigger({
            type: "keypress",
            keyCode: keyCode,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });
        ok(!isDefaultPrevent);
    });

    test('input should not allow minus if not in first position', function () {
        var keyCode = 45;  // minus
        var isDefaultPrevent = false;

        var $input = $('#numerictextbox');

        $input.val('1');

        $input.trigger({ type: "keypress",
            keyCode: keyCode,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
    });

    test('input should append correct decimal separator on key 110 (NumPad Del button)', function () {
        var keyCode = "110";  // 'DEL' button
        var $input = $('#numerictextbox');

        $input.val('1');

        getInput().separator = ',';
        getInput().specialDecimals["110"] = ',';

        $input.trigger({ type: "keydown",
            keyCode: keyCode,
            preventDefault: function () {
            }
        });

        equal($input.val(), "1,");
    });

    test('input should append correct decimal separator when special key is pressed', function () {
        var keyCode = "191";  // 'DEL' button
        var $input = $('#numerictextbox');

        $input.val('1');

        getInput().separator = ',';
        getInput().specialDecimals["191"] = ',';

        $input.trigger({ type: "keydown",
            keyCode: keyCode,
            preventDefault: function () {
            }
        });

        equal($input.val(), "1,");
    });

    test('input should allow decimal separator', function () {
        var keyCode = "190";  // '.'
        var isDefaultPrevent = false;
        var $input = $('#numerictextbox');

        $input.val('1');

        getInput().separator = '.';

        $input.trigger({ type: "keydown",
            keyCode: keyCode,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(!isDefaultPrevent);
    });

    test('input should not allow decimal separator if it is already entered', function () {
        var keyCode = "190";  // '.'
        var isDefaultPrevent = false;
        var $input = $('#numerictextbox');

        $input.val('1.');

        getInput().separator = '.'

        $input.trigger({ type: "keydown",
            keyCode: keyCode,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
    });

    test('value method should set val property', function() {

        var input = getInput();

        input.value(123);

        equal(input.val.toString(), '123');
    });
    
    test('if input value is changed manually should be able to parse it on down button', function() {
        var input = getInput();

        input.value(123);

        $('#numerictextbox')
            .val('100')
            .siblings()
            .filter('.t-arrow-down')
                .trigger({
                    type: 'mousedown',
                    which: 1
                });

        equal(input.value(), 99);
    });

    test('inRange method with min and max should return check value', function() {
        var input = getInput();

        ok(input.inRange(10, 0, 100));
    });

    test('inRange method should return true if key is null', function() {
        var input = getInput();

        ok(input.inRange(null, 0, 100));
    });

    test('if input value is bigger then maxValue blur event should change input value to maxValue', function () {
        var $input = $('#numerictextbox2'),
            textBox = getInput('#numerictextbox2');
        
        textBox.$wrapper.focusin();

        $input.val(100).focus().blur();

        textBox.$wrapper.focusout();

        equal(textBox.maxValue, 80);
        equal(parseInt($input.val()), textBox.maxValue);
    });

    test('if input value is bigger then maxValue blur event should change remove error class', function() {
        var $input = $('#numerictextbox2').find('> .t-input:first');

        var oldSetTimeOut = window.setTimeout;

        try {
            window.setTimeout = function (callback, time) { callback(); }

            $input.val(100)
                    .trigger({ type: 'keydown' })
                    .trigger({ type: 'change' });

            ok(!$input.hasClass('t-state-error'));
        } finally {
            window.setTimeout = oldSetTimeOut;
        }
    });

    test('if input value is smaller then minValue blur event should change input value to minValue', function () {
        var $input = $('#numerictextbox2'),
            textBox = getInput('#numerictextbox2');
        textBox.$wrapper.focusin();
        $input.val(0).focus().blur();
        textBox.$wrapper.focusout();

        equal(parseInt($input.val()), textBox.minValue);
    });

    test('if input value is smaller then minValue blur event should change remove error class', function () {
        var $input = $('#numerictextbox2').addClass('t-state-error');
        var textBox = getInput('#numerictextbox2');

        textBox.$wrapper.focusin();
        $input.focus().blur();
        textBox.$wrapper.focusout();

        ok(!$input.hasClass('t-state-error'));
    });

    test('blur method with null set default text', function() {
        var textbox = getInput('#numerictextbox2');
        var oldSetTimeOut = window.setTimeout;

        try {
            window.setTimeout = function (callback, time) { callback(); }

            textbox.value(null);
            equal(textbox.$text.html(), textbox.text);
        } finally {
            window.setTimeout = oldSetTimeOut;
        }
    });

    test('_paste method should get input value and call _update method if value is correctly parsed', function () {
        var textbox = getInput('#numerictextbox2');
        var oldSetTimeOut = window.setTimeout;
        var oldUpdate = textbox._update;
        var parsedValue;

        try {

            window.setTimeout = function (callback, time) { callback(); }
            textbox._update = function (v) { parsedValue = v; }
            textbox.value(null);
            textbox.$element.val(8);

            textbox.$element.trigger({ type: "paste" });

            equal(parsedValue, 8);
        } finally {
            window.setTimeout = oldSetTimeOut;
            textbox._update = oldUpdate;
        }
    });
    
</script>

</asp:Content>