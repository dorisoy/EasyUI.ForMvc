<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Clipboard</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    
    <script type="text/javascript">
    var editor;
    var clipboard;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



    QUnit.testStart = function() {
        editor = getEditor();
        clipboard = editor.clipboard;
    }

    test('paste empty content', function() {
        var range = createRangeFromText(editor, 'fo||o');
        editor.selectRange(range);
        clipboard.paste('');
        range = editor.getRange();
        equal(editor.value(), 'foo');
        equal(range.startOffset, 2);
        equal(range.startContainer, editor.body.firstChild);
        ok(range.collapsed);
    });

    test('paste text inserts it at caret position', function() {
        var range = createRangeFromText(editor, 'fo||o');
        editor.selectRange(range);
        clipboard.paste('bar');
        range = editor.getRange();
        equal(editor.value(), 'fobaro');
        equal(range.startOffset, 5);
        equal(range.startContainer, editor.body.firstChild);
        ok(range.collapsed);
    });
    
    test('paste inline inserts it at caret position', function() {
        var range = createRangeFromText(editor, 'fo||o');
        editor.selectRange(range);
        
        clipboard.paste('bar<strong>baz</strong>');
        equal(editor.value(), 'fobar<strong>baz</strong>o');
    });

    test('paste inline in inline', function() {
        var range = createRangeFromText(editor, '<strong>fo||o</strong>');
        editor.selectRange(range);
        clipboard.paste('<em>baz</em>');
        equal(editor.value(), '<strong>fo</strong><em>baz</em><strong>o</strong>');
    });

    test('paste deletes contents', function() {
        var range = createRangeFromText(editor, '<strong>|foo|</strong>');
        editor.selectRange(range);
        clipboard.paste('bar');
        equal(editor.value(), 'bar');
    });

    test('paste single block in inline', function() {
        var range = createRangeFromText(editor, '<strong>fo||o</strong>');
        editor.selectRange(range);
        clipboard.paste('<div>bar</div>');
        equal(editor.value(), '<strong>fo</strong><div>bar</div><strong>o</strong>');
    });

    test('paste block in paragraph splits the paragraph', function() {
        var range = createRangeFromText(editor, '<p>fo||o</p>');
        editor.selectRange(range);
        clipboard.paste('<div>bar</div>');
        equal(editor.value(), '<p>fo</p><div>bar</div><p>o</p>');
    });
    
    test('paste block in paragraph which contains inline splits the paragraph', function() {
        var range = createRangeFromText(editor, '<p><span>fo||o</span></p>');
        editor.selectRange(range);
        clipboard.paste('<div>bar</div>');
        equal(editor.value(), '<p><span>fo</span></p><div>bar</div><p><span>o</span></p>');
    });

    test('paste inline content in block element does not split', function() {
        var range = createRangeFromText(editor, '<p>fo||o</p>');
        editor.selectRange(range);
        clipboard.paste('bar');
        equal(editor.value(), '<p>fobaro</p>');
    });
    
    test('paste inline content in block with inline child element splits', function() {
        var range = createRangeFromText(editor, '<p><span>fo||o</span></p>');
        editor.selectRange(range);
        clipboard.paste('bar');
        equal(editor.value(), '<p><span>fo</span>bar<span>o</span></p>');
    });

    test('paste inline content in block with nested inline child element splits', function() {
        var range = createRangeFromText(editor, '<p><span><strong>fo||o</strong></span></p>');
        editor.selectRange(range);
        clipboard.paste('bar');
        equal(editor.value(), '<p><span><strong>fo</strong></span>bar<span><strong>o</strong></span></p>');
    });

    test('empty elements are not stripped', function() {
        var range = createRangeFromText(editor, '<p><img />fo||o</p>');
        editor.selectRange(range);
        clipboard.paste('bar');
        equal(editor.value(), '<p><img />fobaro</p>');
    });

    test('paste block in li splits ul', function() {
        var range = createRangeFromText(editor, '<ul><li>fo||o</li></ul>');
        editor.selectRange(range);
        clipboard.paste('<div>bar</div>');
        equal(editor.value(), '<ul><li>fo</li></ul><div>bar</div><ul><li>o</li></ul>');
    });
    
    test('paste block in td does not split', function() {
        var range = createRangeFromText(editor, '<table><tr><td>fo||o</td></tr></table>');
        editor.selectRange(range);
        clipboard.paste('<div>bar</div>');
        equal(editor.value(), '<table><tbody><tr><td>fo<div>bar</div>o</td></tr></tbody></table>');
    });

    test('paste invalid list markup', function() {
        var range = createRangeFromText(editor, 'f||oo');
        editor.selectRange(range);
        clipboard.paste('<li>foo</li>');
        equal(editor.value(), 'f<ul><li>foo</li></ul>oo');
    });

    test('paste multiple lines from notepad', function() {
        var range = createRangeFromText(editor, 'f||oo');
        editor.selectRange(range);
        clipboard.paste('<div class="t-paste-container">bar</div><div class="t-paste-container">baz</div>');
        equal(editor.value(), 'fbar<br />bazoo');
    });

</script>

</asp:Content>