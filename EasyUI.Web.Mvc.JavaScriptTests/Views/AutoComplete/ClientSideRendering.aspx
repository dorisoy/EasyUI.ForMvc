<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>AutoComplete Client Rendering</h2>

    <input id="AutoComplete" value="AutoCompleteValue"/>

    <% Html.EasyUI().ScriptRegistrar().DefaultGroup(group => group.Add("easyui.common.js")
                                                                   .Add("easyui.list.js")
                                                                   .Add("easyui.autocomplete.js")); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
    var $input;
    var $select;
    module("AutoComplete / ClientSideRendering", {
        setup: function () {
            $input = $('#AutoComplete');

            $input.tAutoComplete();
        }
    });

    test('easyui CSS classes should be added to the input element', function () {
        ok($input.hasClass('t-widget'), 't-widget class was not added');
        ok($input.hasClass('t-autocomplete'), 't-autocomplete class was not added');
        ok($input.hasClass('t-input'), 't-input class was not added');
    });

</script>
</asp:Content>