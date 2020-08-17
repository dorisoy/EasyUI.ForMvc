<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Editor().Name("Editor") %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

    <script type="text/javascript">

        var editor;
        var ListFormatFinder;

        module("Editor / ListFormatFinder", {
            setup: function() {
                editor = getEditor();
                ListFormatFinder = $.easyui.editor.ListFormatFinder;
            }
        });

        test('isFormatted returns false for text node', function() {
            editor.value('test');
            var finder = new ListFormatFinder('ul');
            ok(!finder.isFormatted([editor.body.firstChild]));
        });

        test('isFormatted returns false for mixed selection node', function () {
            editor.value('<ul><li>foo</li></ul><p>bar</p>');
            var finder = new ListFormatFinder('ul');
            ok(!finder.isFormatted([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild.firstChild]));
        });

        test('isFormatted returns true for list', function() {
            editor.value('<ul><li>foo</li></ul>');
            var finder = new ListFormatFinder('ul');
            ok(finder.isFormatted([editor.body.firstChild.firstChild.firstChild]));
        });

        test('isFormatted returns true for list items from the same list', function() {
            editor.value('<ul><li>foo</li><li>bar</li></ul>');
            var finder = new ListFormatFinder('ul');
            ok(finder.isFormatted([editor.body.firstChild.firstChild.firstChild, editor.body.firstChild.lastChild.firstChild]));
        });

        test('isFormatted returns false for two lists', function() {
            editor.value('<ul><li>foo</li></ul><ul><li>bar</li></ul>');
            var finder = new ListFormatFinder('ul');
            ok(!finder.isFormatted([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild.firstChild.firstChild]));
        });

        test('findSuitable returns ul', function() {
            editor.value('<ul><li>foo</li></ul>bar');
            var finder = new ListFormatFinder('ul');
            equal(finder.findSuitable([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild]), editor.body.firstChild);
        });
        
        test('findSuitable returns first ul for adjacent lists', function() {
            editor.value('<ul><li>foo</li></ul><ul><li>bar</li></ul>');
            var finder = new ListFormatFinder('ul');
            equal(finder.findSuitable([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild.firstChild.firstChild]), editor.body.firstChild);
        });

        test('findSuitable returns null when ul is not fist sibling', function() {
            editor.value('<ol><li>foo</li></ol><ul><li>bar</li></ul>');
            var finder = new ListFormatFinder('ul');
            ok(null === finder.findSuitable([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild.firstChild.firstChild]));
        });

        test('isFormatted returns false in mixed list scenario', function() {
            editor.value('<ol><li>foo<ul><li>bar</li></ul></li></ol>');
            var finder = new ListFormatFinder('ol');
            ok(!finder.isFormatted([$(editor.body).find('ul li')[0].firstChild]));
        });

        test('findSuitable returns null when ul is nested in ol', function() {
            editor.value('<ol><li>foo<ul><li>bar</li></ul></li></ol>');
            var finder = new ListFormatFinder('ol');
            ok(null === finder.findSuitable([$(editor.body).find('ul li')[0].firstChild]));
        });

    </script>

</asp:Content>