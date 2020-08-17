<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        BlockFormatter</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    <script type="text/javascript">

        var editor;

        var BlockFormatter;
        var TextNodeEnumerator;
        var enumerator;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
            BlockFormatter = $.easyui.editor.BlockFormatter;
            TextNodeEnumerator = $.easyui.editor.TextNodeEnumerator;
        }

        test('apply format on suitable block node', function() {
            editor.value('<div>foo</div>');

            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            formatter.apply([editor.body.firstChild.firstChild]);

            equal(editor.value(), '<div style="text-align:center;">foo</div>');
        });

        test('apply wraps single node', function() {
            editor.value('foo');
            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            
            formatter.apply([editor.body.firstChild]);

            equal(editor.value(), '<div style="text-align:center;">foo</div>');
        });

        test('apply wraps all inline nodes', function() {
            editor.value('<span>foo</span><span>bar</span>');

            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            formatter.apply([editor.body.firstChild.firstChild, editor.body.lastChild.firstChild]);
            equal(editor.value(), '<div style="text-align:center;"><span>foo</span><span>bar</span></div>');
        });

        test('apply wraps block and inline nodes', function() {
            editor.value('<div>foo</div><span>bar</span>');

            var formatter = new BlockFormatter(editor.formats.justifyCenter);

            formatter.apply([editor.body.firstChild.firstChild, editor.body.lastChild.firstChild]);
            equal(editor.value(), '<div style="text-align:center;">foo</div><div style="text-align:center;"><span>bar</span></div>');
        });

        test('apply for block nodes', function() {
            editor.value('<div>foo</div><div>bar</div>');

            var formatter = new BlockFormatter(editor.formats.justifyCenter);

            formatter.apply([editor.body.firstChild.firstChild, editor.body.lastChild.firstChild]);
            equal(editor.value(), '<div style="text-align:center;">foo</div><div style="text-align:center;">bar</div>');
        });

        test('apply for text and block', function() {
            editor.value('foo<div>bar</div>baz');

            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            formatter.apply([editor.body.firstChild, editor.body.childNodes[1].firstChild, editor.body.lastChild]);
            equal(editor.value(), '<div style="text-align:center;">foo</div><div style="text-align:center;">bar</div><div style="text-align:center;">baz</div>');
        });

        test('apply text node and inline elements', function() {
            editor.value('foo<span></span>bar<span></span>baz');

            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            formatter.apply([editor.body.childNodes[2]]);
            equal(editor.value(), '<div style="text-align:center;">foo<span></span>bar<span></span>baz</div>');
        });

        test('remove unwraps text node', function() {
            editor.value('<div style="text-align:center">foo</div>');
            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            formatter.remove([editor.body.firstChild.firstChild]);
            equal(editor.value(), 'foo');
        });

        test('remove preserves paragraphs', function() {
            editor.value('<p style="text-align:center">foo</p>');
            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            formatter.remove([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<p>foo</p>');
        });

        test('remove unwraps block nodes', function() {
            editor.value('<div style="text-align:center">foo</div><div style="text-align:center">bar</div>');
            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            formatter.remove([editor.body.firstChild.firstChild, editor.body.lastChild.firstChild]);
            equal(editor.value(), 'foobar');
        });


        test('toggle applies format if format is not found', function() {
            var range = createRangeFromText(editor, '|fo|');

            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            var argument;
            formatter.apply = function () {
                argument = arguments[0];
            }
            formatter.toggle(range);
            ok($.isArray(argument));
        });

        test('toggle removes format if format is found', function() {
            var range = createRangeFromText(editor, '<div style="text-align:center">|fo|</div>');

            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            var argument;
            formatter.remove = function () {
                argument = arguments[0];
            }
            formatter.toggle(range);
            ok($.isArray(argument));
        });

        test('toggle and empty range', function() {
            editor.value('foo');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 0);
            range.setEnd(editor.body.firstChild, 0);
            var formatter = new BlockFormatter(editor.formats.justifyCenter);
            formatter.toggle(range);
            equal(editor.value(), '<div style="text-align:center;">foo</div>');
        });

        test('toggle on image', function() {
            editor.value('<img src="foo" />');

            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);

            var formatter = new BlockFormatter(editor.formats.justifyRight);
            formatter.toggle(range);
            
            equal(editor.value(), '<img src="foo" style="float:right;" />');
        });

        test('toggle on image in paragarph', function() {
            editor.value('<p><img src="foo" /></p>');

            var range = editor.createRange();
            range.selectNode(editor.body.firstChild.firstChild);

            var formatter = new BlockFormatter(editor.formats.justifyRight);
            formatter.toggle(range);
            
            equal(editor.value(), '<p><img src="foo" style="float:right;" /></p>');
        });

        test('remove on image', function() {
            editor.value('<img style="float:right" src="foo" />');

            var formatter = new BlockFormatter(editor.formats.justifyRight);
            
            formatter.remove([editor.body.firstChild]);
            
            equal(editor.value(), '<img src="foo" />');
        });
        
        test('apply attribute on td', function() {
            editor.value('<table><tr><td>foo</td></tr></table>');
            var td = $('td', editor.body)[0];
            var formatter = new BlockFormatter(editor.formats.justifyRight);
            
            formatter.apply([td.firstChild]);
            
            equal(editor.value(), '<table><tbody><tr><td style="text-align:right;">foo</td></tr></tbody></table>');
        });

        test('apply wrap in td', function() {
            editor.value('<table><tr><td>foo</td></tr></table>');
            var td = $('td', editor.body)[0];
            var formatter = new BlockFormatter([{tags:['p']}]);
            
            formatter.apply([td.firstChild]);
            
            equal(editor.value(), '<table><tbody><tr><td><p>foo</p></td></tr></tbody></table>');
        });
        
        test('apply to selection of block elements', function() {
            editor.value('<div>foo</div><div>bar</div><div>baz</div>');
            var formatter = new BlockFormatter(editor.formats.justifyRight);
            formatter.apply([editor.body.firstChild.firstChild, editor.body.firstChild.nextSibling.firstChild]);
            equal(editor.value(), '<div style="text-align:right;">foo</div><div style="text-align:right;">bar</div><div>baz</div>');
        });

        test('apply wraps in div', function() {
            editor.value('<div>foo</div>');
            var formatter = new BlockFormatter([{tags:['p']}]);
            
            formatter.apply([editor.body.firstChild.firstChild]);
            
            equal(editor.value(), '<div><p>foo</p></div>');
        });

        test('apply empty container', function() {
            editor.value('');
            editor.focus();
            editor.exec('justifyRight');
            var range = editor.getRange();
            range.insertNode(editor.document.createElement('a'));
            equal(editor.value(), '<div style="text-align:right;"><a></a></div>');
        });


        test('apply text nodes in inline element', function() {
            editor.value('<span>foo<strong>bar</strong></span>');
            var formatter = new BlockFormatter(editor.formats.justifyRight);
            
            formatter.apply([editor.body.firstChild.firstChild, editor.body.firstChild.lastChild.firstChild]);
            
            equal(editor.value(), '<div style="text-align:right;"><span>foo<strong>bar</strong></span></div>');
        });

</script>

</asp:Content>