<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>ComboBox Client Rendering</h2>

    <input id="ComboBox" value="ComboBoxValue"/>
    <% Html.BeginForm(); %>
        <select id="selectList" name="selectList">
            <option value="">SelectItem</option>
            <option value="1">Item1</option>
            <option value="2" selected="selected">Item2</option>
            <option value="3">Item3</option>
        </select>
        <button type="submit">Submit</button>    
    <% Html.EndForm(); %>

    <% Html.EasyUI().ScriptRegistrar().DefaultGroup(group => group.Add("easyui.common.js")
                                                                   .Add("easyui.list.js")
                                                                   .Add("easyui.combobox.js")); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
    var $input;
    var $select;
    module("ComboBox / ClientSideRendering", {
        setup: function () {
            $input = $('#ComboBox');
            $select = $('#selectList');

            $input.tComboBox();
            $select.tComboBox();
        }
    });

    test('element property should be INPUT', function () {
        var element = $input.data('tComboBox').element;
        equal(element.nodeName, 'INPUT', 'wrapper is not created');
        equal(element.style.display, "none");
    });

    test('wrapper property should be DIV wrapper', function () {
        var element = $input.data('tComboBox').$wrapper[0];
        equal(element.nodeName, 'DIV', 'wrapper is not created');
        equal(element.className, 't-widget t-combobox t-header', 'wrapper is not created');
        equal(element.children[0].nodeName, 'DIV', 'DIV which wraps text and button is not rendered');
        equal(element.children[0].className, 't-dropdown-wrap t-state-default', 'DIV which wraps text and button does not have correct CSS class');
    });

    test('input which was wrapped should be hidden', function () { 
        ok(!$input.is(':visible'), 'input was not hidden')
    });

    test('input should be wrapped in t-widget DIV', function () {
        var $text = $input.data('tComboBox').$text;
        equal($text[0].nodeName, 'INPUT', 'text span was not rendered');
        ok($input.parent().hasClass('t-widget'), 'input was not wrapped correctly');
    });

    test('innerHtml should be equal to the input value', function () {
        var $text = $input.data('tComboBox').$text;
        equal($text.val(), $input.val(), 'value was not set');
    });

    test('text span should be nested in t-dropdown-wrap', function () {
        var $text = $input.data('tComboBox').$text;

        ok($text.parent().hasClass('t-dropdown-wrap'));
    });

    test('element property should be DIV wrapper', function () {
        var wrapper = $select.data('tComboBox').$wrapper[0];
        equal(wrapper.nodeName, 'DIV', 'wrapper is not created');
        equal(wrapper.className, 't-widget t-combobox t-header', 'wrapper is not created');
        equal(wrapper.children[0].nodeName, 'DIV', 'DIV which wraps text and button is not rendered');
        equal(wrapper.children[0].className, 't-dropdown-wrap t-state-default', 'DIV which wraps text and button does not have correct CSS class');
    });

    test('select which was wrapped should be hidden', function () {
        ok(!$select.is(':visible'), 'select was not hidden')
    });

    test('innerHtml should be equal to the select text', function () {
        var text = $select.find('option:selected').text();
        var $text = $select.data('tComboBox').$text;
        equal($text.val(), text, 'value was not set');
    });

    test('hidden input should be rendered if the element is HTML select and its properties should be set', function () {
        var select = $('<select id="selectID" name="selectName"><option value="1">Item1<option/></select>');
        select.tComboBox();
        
        var hiddenInput = select.closest('.t-combobox').find('input[name="' + select.attr('name') + '"]');

        equal(hiddenInput.val(), '1', 'property value was not applied correctly');
        equal(hiddenInput.attr('name'), 'selectName', 'property name was not applied correctly');
        ok(!hiddenInput.is(':visible'), 'added input is not hidden');
    });

    test('data should be extracted from select HTML element', function () {
        var select = $select.data('tComboBox');
        var data = select.data;

        var selectedOption = $select.find('option:selected');
        var index = selectedOption.index();

        equal(data.length, 4, 'data was not extracted correctly');
        equal(data[index].Text, selectedOption.text(), 'text property was not get correctly');
        equal(data[index].Value, selectedOption.val(), 'value property was not get correctly');
    });

    test('if data is provided in options, it should be get with priority', function () {
        var $select = $('<select id="selectID" name="selectName"><option value="1">Item1<option/><option>Item2</option></select>');
        $select.tComboBox({ data: [{ Text: "StaticData1", Value: "Value1"}] });

        var selectObject = $select.data('tComboBox');

        equal(selectObject.data.length, 1, 'data was overriden');
        equal(selectObject.data[0].Text, "StaticData1", 'text property is overriden');
        equal(selectObject.data[0].Value, "Value1", 'value property is overriden');
    });

    // the following test will be skipped in Chome and Safari, as they do not support the DOMAttrModified event yet
    test('hidden input CSS class changes should be reflected in the visible input', function () {

        if (jQuery.browser.webkit) {
            return;
        }

        var element = $select.data('tComboBox').$element;
        var text = $select.data('tComboBox').$text
        var additionalClass = "input-validation-field";

        element.attr("class", additionalClass);

        ok(text.attr("class").indexOf(additionalClass) != -1, 'CSS class was not transfered to the visible input');
    });

</script>
</asp:Content>