<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>Ajax loading</h2>
    
    <script type="text/javascript">

        function getComboBox() {
            return $('#AjaxCombo').data('tComboBox');
        }

        //handlers
        function onLoad(e) {
            isRaised = true;
        }

        function onChange(e) {
            isChangeRaised = true;
        }

        function onClose(e) {
            isRaised = true;
        }

        function onOpen(e) {
            isRaised = true;
        }

        function onDataBindingPassData(e) {
            e.data = $.extend({}, e.data, { Test: "test" });
        }

        function onDataBinding(e) {
            isDataBinding = true;
        }

        function onDataBound(e) {
            isDataBound = true;
        }

        function DataBindCombo() {
            getComboBox().dataBind([{ Text: "1", Value: 1, Selected: false }, { Text: "2", Value: 2, Selected: false }, { Text: "3", Value: 3, Selected: false}]);
        }
    </script>
    
    <%= Html.EasyUI().ComboBox()
            .Name("AjaxCombo")
            .Effects(effects => effects.Toggle())
            .DataBinding(binding => binding.Ajax().Select("_AjaxLoading", "ComboBox"))
            .ClientEvents(events => events.OnDataBinding("onDataBinding")
                                        .OnDataBound("onDataBound"))
    %>

    <%= Html.EasyUI().ComboBox()
        .Name("AjaxCombo2")
        .Effects(effects => effects.Toggle())
        .DataBinding(binding => binding.Ajax().Select("_AjaxLoading", "ComboBox"))
        .ClientEvents(events => events.OnDataBinding("onDataBindingPassData"))
    %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        test('fill should call ajaxRequest if ajax enabled', function() {
            var isCalled = false;
            var combo = getComboBox();
            var oldMethod = combo.loader.ajaxRequest;

            combo.loader.ajaxRequest = function () { isCalled = true; };
            combo.minChars = 0;
            combo.dropDown.$items = null;
            combo.fill();

            combo.ajaxRequest = oldMethod;

            ok(isCalled);
        });

        test('fill should not call ajaxRequest if ajax enabled and entered value is shorter than minLetters', function() {
            var isCalled = false;
            var combo = getComboBox();
            var oldMethod = combo.loader.ajaxRequest;

            combo.$text.val('')

            var minChars = combo.minChars;
            combo.minChars = 1;

            combo.loader.ajaxRequest = function () { isCalled = true; };

            combo.fill();

            combo.loader.ajaxRequest = oldMethod;
            combo.minChars = minChars;

            ok(!isCalled);
        });

        test('fill should pass custom parameters to the ajaxRequest', function() {
            var ajaxOptions;
            var testText = "test";
            var combo = $('#AjaxCombo2').data('tComboBox');
            var old = $.ajax;
            
            combo.$text.val(testText)

            $.ajax = function (result) { ajaxOptions = result; };
            
            combo.fill();

            $.ajax = old;

            equal(ajaxOptions.data.Test, testText);
        });

</script>

</asp:Content>