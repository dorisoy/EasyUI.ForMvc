<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>DropDownList Client Rendering</h2>

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
                                                                   .Add("easyui.list.js")); %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
    var $input;
    var $select;
    module("DropDownList / ClientSideRendering", {
        setup: function () {
            $select = $('#selectList');
            $select.tDropDownList();
        }
    });

    test('element property should be INPUT', function () {
        var element = $select.data('tDropDownList').element;
        equal(element.nodeName, 'INPUT', 'element property is not correctly assigned');
        equal(element.style.display, 'none');
    });

    test('wrapper should be input wrapper', function () {
        var wrapper = $select.data('tDropDownList').$wrapper[0];
        equal(wrapper.nodeName, 'DIV', 'wrapper is not created');
        equal(wrapper.className, 't-widget t-dropdown t-header', 'wrapper is not created');
        equal(wrapper.children[0].nodeName, 'DIV', 'DIV which wraps text and button is not rendered');
        equal(wrapper.children[0].className, 't-dropdown-wrap t-state-default', 'DIV which wraps text and button does not have correct CSS class');
    });

    test('select which was wrapped should be hidden', function () {
        ok(!$select.is(':visible'), 'select was not hidden')
    });

    test('innerHtml should be equal to the select text', function () {
        var $text = $select.data('tDropDownList').$text;
        var text = $select.find('option:selected').text();
        equal(text, $text.html(), 'value was not set');
    });

    test('innerHtml should set $nbsp; if select value is empty', function () {
        var select = $('<select/>');
        select.tDropDownList();
        var $text = select.closest('.t-dropdown').find('.t-input');
        equal($text.html(), '&nbsp;', '&nbsp; was not rendered');
    });

    test('hidden input should be rendered if the element is HTML select and its properties should be set', function () {
        var select = $('<select id="selectID" name="selectName"><option value="1">Item1<option/></select>');
        select.tDropDownList();

        var hiddenInput = select.closest('.t-dropdown').find('input');

        equal(hiddenInput.val(), '1', 'property value was not applied correctly');
        equal(hiddenInput.attr('name'), 'selectName', 'property name was not applied correctly');
        ok(!hiddenInput.is(':visible'), 'added input is not hidden');
    });

    test('data should be extracted from select HTML element', function () {
        var select = $select.data('tDropDownList');
        var data = select.data;

        var selectedOption = $select.find('option:selected');
        var index = selectedOption.index();

        equal(data.length, 4, 'data was not extracted correctly');
        equal(data[index].Text, selectedOption.text(), 'text property was not get correctly');
        equal(data[index].Value, selectedOption.val(), 'value property was not get correctly');
    });

    test('if data is provided in options, it should be get with priority', function () {
        var $select = $('<select id="selectID" name="selectName"><option value="1">Item1<option/><option>Item2</option></select>');
        $select.tDropDownList({ data: [{ Text: "StaticData1", Value: "Value1"}] });

        var selectObject = $select.data('tDropDownList');

        equal(selectObject.data.length, 1, 'data was overriden');
        equal(selectObject.data[0].Text, "StaticData1", 'text property is overriden');
        equal(selectObject.data[0].Value, "Value1", 'value property is overriden');
    });

    // the following test will be skipped in Chome and Safari, as they do not support the DOMAttrModified event yet
    test('hidden input CSS class changes should be reflected in the dropdown-wrap element', function () {

        if (jQuery.browser.webkit) {
            return;
        }

        var additionalClass = "input-validation-field";
        var innerWrap = $("#selectList").data("tDropDownList").$wrapper.find(">.t-dropdown-wrap");

        $select.data('tDropDownList').$element.attr("class", additionalClass);
        
        ok(innerWrap.attr("class").indexOf(additionalClass) != -1, 'CSS class was not transfered to the inner wrapper');
    });

</script>
</asp:Content>