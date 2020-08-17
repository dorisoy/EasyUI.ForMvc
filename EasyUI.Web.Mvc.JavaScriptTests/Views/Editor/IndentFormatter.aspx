<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>IndentFormatter</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    
    <script type="text/javascript">

        var editor, IndentFormatter, TextNodeEnumerator;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        QUnit.testStart = function() {
            editor = getEditor();
            IndentFormatter = $.easyui.editor.IndentFormatter;
            TextNodeEnumerator = $.easyui.editor.TextNodeEnumerator;
        }

        test('apply to text node', function() {
            editor.value('foo');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild]);
            equal(editor.value(), '<div style="margin-left:30px;">foo</div>');
        });

        test('apply to inline node', function() {
            editor.value('<span>foo</span>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<div style="margin-left:30px;"><span>foo</span></div>');
        });
        
        test('apply to block node', function() {
            editor.value('<div>foo</div>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<div style="margin-left:30px;">foo</div>');
        });
        
        test('apply to selection', function() {
            editor.value('<div>foo</div><div>bar</div>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.firstChild,editor.body.lastChild.firstChild]);
            equal(editor.value(), '<div style="margin-left:30px;">foo</div><div style="margin-left:30px;">bar</div>');
        });

        test('remove from selection', function() {
            editor.value('<div style="margin-left:30px;">foo</div><div style="margin-left:30px;">bar</div>');
            formatter = new IndentFormatter();
            formatter.remove([editor.body.firstChild.firstChild,editor.body.lastChild.firstChild]);
            equal(editor.value(), '<div>foo</div><div>bar</div>');
        });

        test('apply increases margin', function() {
            editor.value('<div style="margin-left:30px">foo</div>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<div style="margin-left:60px;">foo</div>');
        });

        test('remove removes margin', function() {
            editor.value('<div style="margin-left:30px">foo</div>');
            formatter = new IndentFormatter();
            formatter.remove([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<div>foo</div>');
        });

        test('remove decreases margin', function() {
            editor.value('<div style="margin-left:60px">foo</div>');
            formatter = new IndentFormatter();
            formatter.remove([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<div style="margin-left:30px;">foo</div>');
        });

        test('apply first li adds margin to ul', function() {
            editor.value('<ul><li>foo</li></ul>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.firstChild.firstChild]);
            equal(editor.value(), '<ul style="margin-left:30px;"><li>foo</li></ul>');
        });
        
        test('apply selection of li including first adds margin to ul', function() {
            editor.value('<ul><li>foo</li><li>bar</li></ul>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.firstChild.firstChild,editor.body.firstChild.lastChild.firstChild]);
            equal(editor.value(), '<ul style="margin-left:30px;"><li>foo</li><li>bar</li></ul>');
        });

        test('apply second li nests in previous li', function() {
            editor.value('<ul><li>foo</li><li>bar</li></ul>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.lastChild.firstChild]);
            equal(editor.value(), '<ul><li>foo<ul><li>bar</li></ul></li></ul>');
        });

        test('apply reuses nested list', function() {
            editor.value('<ul><li>foo<ul><li>baz</li></ul></li><li>bar</li></ul>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.lastChild.firstChild]);
            equal(editor.value(), '<ul><li>foo<ul><li>baz</li><li>bar</li></ul></li></ul>');
            
        });

        test('apply nests selected lis in previous li', function() {
            editor.value('<ul><li>foo</li><li>bar</li><li>baz</li></ul>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.firstChild.nextSibling.firstChild, editor.body.firstChild.lastChild.firstChild]);
            equal(editor.value(), '<ul><li>foo<ul><li>bar</li><li>baz</li></ul></li></ul>');
        });

        test("remove when dom is invalid", function() {
            editor.value("<ul><li>foo</li><ul><li>bar</li></ul></ul>")
            formatter = new IndentFormatter();
            formatter.remove([editor.body.firstChild.lastChild.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });

        test('remove first li removes margin from ul', function() {
            editor.value('<ul style="margin-left:30px;"><li>foo</li></ul>');
            formatter = new IndentFormatter();
            formatter.remove([editor.body.firstChild.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li></ul>');
        });
        
        test('remove nested li unnests it', function() {
            editor.value('<ul><li>foo<ul><li>bar</li></ul></li></ul>');
            formatter = new IndentFormatter();
            formatter.remove([$(editor.body).find('ul ul li:first')[0].firstChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });

        test('remove nested li unnests it and nests siblings', function() {
            editor.value('<ul><li>foo<ul><li>bar</li><li>baz</li></ul></li></ul>');
            formatter = new IndentFormatter();
            formatter.remove([$(editor.body).find('ul ul li:first')[0].firstChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar<ul><li>baz</li></ul></li></ul>');
        });

        test('apply non-first parent li merges it with its child', function() {
            editor.value('<ul><li>foo</li><li>bar<ul><li>baz</li></ul></li></ul>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.lastChild.firstChild]);
            equal(editor.value(), '<ul><li>foo<ul><li>bar</li><li>baz</li></ul></li></ul>');
        });

        test('apply non-first parent li merges it with its sibling', function() {
            editor.value('<ul><li>foo<ul><li>bar</li></ul></li><li>baz<ul><li>boo</li></ul></li></ul>');
            formatter = new IndentFormatter();
            formatter.apply([editor.body.firstChild.lastChild.firstChild]);
            equal(editor.value(), '<ul><li>foo<ul><li>bar</li><li>baz</li><li>boo</li></ul></li></ul>');
        });

        test('double nested li removes margin', function() {
            editor.value('<ul><li>foo<ul style="margin-left:30px;"><li>bar</li></ul></li></ul>');
            formatter = new IndentFormatter();
            formatter.remove([$(editor.body).find('ul ul li:first')[0].firstChild]);
            equal(editor.value(), '<ul><li>foo<ul><li>bar</li></ul></li></ul>');
        });

        test("remove from indented lists with more than one item", function() {
            editor.value('<ul style="margin-left:60px"><li>foo</li><li>bar</li></ul>');
            formatter = new IndentFormatter();
            formatter.remove([editor.body.firstChild.firstChild.firstChild, editor.body.firstChild.lastChild.firstChild]);
            equal(editor.value(), '<ul style="margin-left:30px;"><li>foo</li><li>bar</li></ul>');
        });
</script>

</asp:Content>