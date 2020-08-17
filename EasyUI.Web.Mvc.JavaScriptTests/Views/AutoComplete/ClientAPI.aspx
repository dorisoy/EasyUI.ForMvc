<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().AutoComplete()
            .Name("AutoComplete")
    %>

    <br />
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getAutoComplete() {
            return $('#AutoComplete').data('tAutoComplete');
        }

        test('fill method should call component dataBind method', function () {
            var autoComplete = getAutoComplete();

            var isCalled = false;
            var old = autoComplete.dataBind;
            autoComplete.dataBind = function () { isCalled = true; };
            autoComplete.dropDown.$items = null;
            autoComplete.fill();

            ok(isCalled);

            autoComplete.dataBind = old;
        });

        test('enable method should enable autoComplete', function() {
            var autoComplete = getAutoComplete();

            autoComplete.enable();
            autoComplete.disable();

            ok($('#AutoComplete').hasClass('t-state-disabled'));
            equal($('#AutoComplete').attr('disabled'), 'disabled');
        });

        test('enable method should disable autoComplete', function() {
            var autoComplete = getAutoComplete();

            autoComplete.disable();
            autoComplete.enable();

            ok(!$('#AutoComplete').hasClass('t-state-disabled'));
            ok(!$('#AutoComplete').attr('disabled'));
        });

        test('dataBind method should encode Text property if encoded is true', function () {
            var decodedText = '<>&Visit W3Schools!';
            var autocomplete = getAutoComplete();
            var old = autocomplete.loader.isAjax;
            autocomplete.loader.isAjax = function () { return true; }

            var dataSource = [
                { Text: decodedText, Value: decodedText },
                { Text: "Product 2", Value: "2" }
            ];
            
            autocomplete.dataBind(dataSource);

            autocomplete.loader.isAjax = old;

            equal('&lt;&gt;&amp;Visit W3Schools!', autocomplete.dropDown.$items.eq(0).html(), 'Text property is not encoded');
            equal(dataSource[0].Value, autocomplete.data[0].Value);
        });

        test('dataBind method should encode data if encoded is true', function () {
            var decodedText = '<>&Visit W3Schools!';
            var autocomplete = getAutoComplete();

            var old = autocomplete.loader.isAjax;
            autocomplete.loader.isAjax = function () { return true; }

            var dataSource = [
                decodedText,
                "Product 2"
            ];

            autocomplete.dataBind(dataSource);

            autocomplete.loader.isAjax = old;

            equal('&lt;&gt;&amp;Visit W3Schools!', autocomplete.dropDown.$items.eq(0).html(), 'Text property is not encoded');
        });

        test('dataBind method should not encode Text property if encoded is true and isAjax returns false', function () {
            var autocomplete = getAutoComplete();
            var old = autocomplete.loader.isAjax;
            autocomplete.loader.isAjax = function () { return false; }

            var dataSource = [
                "&lt;&gt;&amp;Visit W3Schools!",
                "Product 2"
            ];

            autocomplete.dataBind(dataSource);

            autocomplete.loader.isAjax = old;

            equal('&lt;&gt;&amp;Visit W3Schools!', autocomplete.data[0], 'Text property is encoded twice');
        });

        test('dataBind method should not throw exception if item is null', function () {
            var decodedText = '<>&Visit W3Schools!';
            var autocomplete = getAutoComplete();
            var old = autocomplete.loader.isAjax;
            autocomplete.loader.isAjax = function () { return true; }

            var dataSource = [
                { Text: decodedText, Value: decodedText },
                null
            ];

            var result;

            try {
                autocomplete.dataBind(dataSource);
                result = true;
            } catch (e) {
                result = false;
            } finally {
                autocomplete.loader.isAjax = old;
                ok(result);
            }
        });

        test("value method should set value of the AutoComplete and previousValue property", function () {
            var autocomplete = getAutoComplete();
            autocomplete.value("test");

            equal(autocomplete.value(), "test");
            equal(autocomplete.previousValue, "test");
        });

</script>

</asp:Content>