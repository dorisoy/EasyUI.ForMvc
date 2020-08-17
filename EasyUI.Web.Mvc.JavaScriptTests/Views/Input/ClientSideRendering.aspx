<%@ Page Title="CollapseDelay Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        CollapseDelay Tests</h2>
     <%= Html.EasyUI().NumericTextBox()
             .Name("numerictextbox")
             .Value(5)
             .MinValue(1)
             .MaxValue(8)
     %>
     <br />
     <input name="clientNumeric" id="clientNumeric" />
     <input id="Text1" value="1000"/>

    <script type="text/javascript">

        function getInput(selector) {
            return $(selector || "#numerictextbox").data("tTextBox");
        }

    </script>

<% Html.EasyUI().ScriptRegistrar().OnDocumentReady(() => { 
    %>
       jQuery('#clientNumeric').tTextBox();
    <%
   })
   .Globalization(true); %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    test('tTextBox should render div', function () {
        var $textbox = $("#numerictextbox");
        equal(1, $textbox.siblings().filter('div').length, 'div was not rendered')
    });

    test('input value should be applied to the rendered div', function () {
        var $textbox = $("#numerictextbox");

        equal(parseFloat(getInput().value()), parseFloat($textbox.siblings().filter('div').html()), 'parsed input and div values do not match')
    });

    test('On initialization tTextBox should render input numerictexbox wrapper if type is not defined', function () {
        var $clientInput = $('#clientNumeric');
        var $wrapper = $clientInput.parent();

        equal($wrapper.length, 1, 'wrapper div was not rendered');
        ok($wrapper.hasClass('t-widget'), 'does not have t-wrapper test');
        ok($wrapper.hasClass('t-numerictextbox'), 'does not have t-numerictextbox test');
    });

    test('input color should be equal to the background-color', function () {
        equal($('#numerictextbox').css("color"), $('#numerictextbox').css("background-color"));
    });

</script>

</asp:Content>