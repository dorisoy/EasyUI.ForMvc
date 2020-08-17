<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <%= Html.EasyUI().NumericTextBox()
          .Name("NumericTextBox")
          .ClientEvents(e => e.OnLoad("onLoad").OnChange("onChange"))
  %>
    <script type="text/javascript">

        var onLoadNumericTextBox, oldValue, newValue, element;

        function onLoad() {
            onLoadNumericTextBox = $(this).data('tTextBox');
        }

        function onChange(e) {
            e.preventDefault();
            element = this;
            oldValue = e.oldValue;
            newValue = e.newValue;
            componentValueInChangeHandler = $(this).data("tTextBox").value();
        }

        function getInput() {
            return $('#NumericTextBox').data('tTextBox');
        }
    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

 
    test('client object is available in on load', function() {
        ok(null !== onLoadNumericTextBox);
        ok(undefined !== onLoadNumericTextBox);
    });

    test('change event should be raised when type number and blur', function () {
        var numeric = getInput();

        numeric.value(null);

        numeric.$wrapper.focusin();
        numeric.$element.val('10.11111')[0].focus();

        numeric.$element[0].blur();
        numeric.$wrapper.focusout();

        equal(oldValue, null, 'oldValue is not null');
        equal(newValue, 10.11, 'newValue is not 10');
    });

    test('value should be fixed on blur', function () {
        var numeric = getInput();

        numeric.value(null);

        numeric.$wrapper.focusin();
        numeric.$element.val('10').focus();

        numeric.$element[0].blur();
        numeric.$wrapper.focusout();

        equal(oldValue, null, 'oldValue is not null');
        equal(newValue, 10, 'newValue is not 10');
    });
    
    test('change event should raise when modify value with up/down arrow', function () {
        var numeric = getInput();

        numeric.value(10);

        numeric._modify(1);

        numeric.$wrapper.focusout();

        equal(oldValue, 10, 'oldValue is not null');
        equal(newValue, 11, 'newValue is not 10');
    });
    
    test('change event should not raise when typed number is out range', function () {
        //reset event handler params
        oldValue = undefined;
        newValue = undefined;
        
        var numeric = getInput();
        var maxValue = numeric.maxValue;

        numeric.value(maxValue);

        numeric.$element.val('10000000000000000000')
        numeric.$wrapper.focusin();

        numeric.$element.trigger('change');

        equal(oldValue, undefined, 'change event was raised incorrectly');
        equal(newValue, undefined, 'change event was raised incorrectly');
    });

    test('change event should call event handler with input context', function () {
        var numeric = getInput();

        numeric.value(10);
        numeric.$element.val('20');

        numeric.$wrapper.focusin();

        equal(element, numeric.element);
    });

    //should be last because of prevent default;
    test('if defaultPrevented in change event, then old value should be chosen', function () {
        var numeric = getInput();

        numeric.value(20);
        
        numeric._update(30);

        equal(numeric.value(), 20);
    });

    test('In change event handler, component value should be the new', function () {
        var numeric = getInput();

        numeric.value(20);

        numeric._update(30);

        equal(componentValueInChangeHandler, 30);
    });

</script>

</asp:Content>