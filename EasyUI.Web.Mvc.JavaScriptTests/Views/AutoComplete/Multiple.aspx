<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    
    <%= Html.EasyUI().AutoComplete()
            .Name("AutoComplete")
            .BindTo(new string[]{
                "Chai", "Chang", "Tofu", "Boysenberry", "Uncle", "Northwoods",
                "Ikura", "Queso", "Manchego", "Dried", "тtem20"
            })
            .Multiple()
            .AutoFill(true) 
    %>

    <% Html.EasyUI().ScriptRegistrar()
           .Scripts(scripts => scripts
               .Add("easyui.common.js")
               .Add("easyui.list.js")
               .Add("easyui.autocomplete.js")); %>

</asp:Content>



<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getAutoComplete() {
            return $('#AutoComplete').data('tAutoComplete');
        }

        test('value method should to set input value', function() {
            var text = "test";
            
            getAutoComplete().value("test");

            equal(getAutoComplete().$text.val(), text);

            getAutoComplete().$text.val('')
        });

        test('value method should return input value', function() {
            var text = "test";

            getAutoComplete().$text.val(text);

            equal(getAutoComplete().value(), text);

            getAutoComplete().$text.val('')
        });

        test('autoFill method should auto fill second word', function() {
            var $t = $.easyui;
            var autocomplete = getAutoComplete();
            var caretPos = $t.caretPos;

            autocomplete.fill();
            autocomplete.$text.val('Chai, Cha, Tofu, ');

            $t.caretPos = function () { return 9; } //return caret position after 'Cha'
            
            autocomplete.filtering.autoFill(autocomplete, "Chang");

            equal(autocomplete.$text.val(), 'Chai, Chang, Tofu, ');

            //revert changes
            autocomplete.$text.val('');
            $t.caretPos = caretPos;
        });

        test('filter method should encode newly retrieved data if encoded true', function () {
            var autocomplete = getAutoComplete();
            var oldData = autocomplete.data;
            var oldAjax = autocomplete.loader.isAjax;
            var decodedText = '<>&Visit W3Schools!';
            var ajaxRequest = autocomplete.loader.ajaxRequest;

            var dataSource = [
                decodedText,
                "Product 2"
            ];

            autocomplete.close();
            autocomplete.cache = false;

            try {
                autocomplete.minChars = -1;
                autocomplete.loader.isAjax = function () { return true; };
                autocomplete.loader.ajaxRequest = function (callback) { callback(dataSource); };
                autocomplete.filtering.filter(autocomplete);

                equal(autocomplete.dropDown.$items.eq(0).html(), '&lt;&gt;&amp;Visit W3Schools!');
            } finally {
                autocomplete.data = oldData;
                autocomplete.loader.isAjax = oldAjax;
                autocomplete.loader.ajaxRequest = ajaxRequest;
            }
        });

</script>

</asp:Content>