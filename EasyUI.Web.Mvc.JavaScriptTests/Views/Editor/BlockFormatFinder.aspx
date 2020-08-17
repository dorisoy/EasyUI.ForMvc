<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Editor().Name("Editor") %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

    <script type="text/javascript">

        var editor;
        var BlockFormatFinder;

        module("Editor / BlockFormatFinder", {
            setup: function() {
                editor = getEditor();
                BlockFormatFinder = $.easyui.editor.BlockFormatFinder;
            }
        });

        test('findSuitable returns suitable container', function() {
            editor.value('<div>foo</div>');
            var finder = new BlockFormatFinder(editor.formats.justifyCenter);

            equal(finder.findSuitable([editor.body.firstChild.firstChild])[0], editor.body.firstChild);
        });

        test('findSuitable returns null if no suitable found', function() {
            editor.value('foo');
            var finder = new BlockFormatFinder(editor.formats.justifyCenter);
            equal(finder.findSuitable([editor.body.firstChild]).length, 0);
        });
        
        test('findSuitable returns all suitable nodes null if no suitable found', function() {
            editor.value('<div>foo</div><div>bar</div>');
            var finder = new BlockFormatFinder(editor.formats.justifyCenter);
            equal(finder.findSuitable([editor.body.firstChild.firstChild, editor.body.lastChild.firstChild]).length, 2);
        });

        test('findSuitable returns distinct nodes', function() {
            editor.value('<div><span>foo</span><span>bar</span></div><div>baz</div>');
            var finder = new BlockFormatFinder(editor.formats.justifyCenter);
            equal(finder.findSuitable([editor.body.firstChild.firstChild.firstChild, editor.body.firstChild.lastChild.firstChild, editor.body.lastChild.firstChild]).length, 2);
        });

        test('findSuitable looks for common ancestor which is suitable', function() {
            editor.value('<div>foo</div>bar');
            var finder = new BlockFormatFinder(editor.formats.justifyCenter);
            equal(finder.findSuitable([editor.body.firstChild.firstChild, editor.body.lastChild]).length, 0);
        });

        test('findSuitable looks for the outer most common ancestor which is suitable', function() {
            editor.value('<div><div>foo</div>bar</div>');
            var finder = new BlockFormatFinder(editor.formats.justifyCenter);

            equal(finder.findSuitable([editor.body.firstChild.firstChild.firstChild, editor.body.firstChild.lastChild])[0], editor.body.firstChild);
        });

        test('findSuitable returns the inner suitable ancestor', function() {
            editor.value('<div><div>foo</div></div>');
            var finder = new BlockFormatFinder(editor.formats.justifyCenter);

            equal(finder.findSuitable([editor.body.firstChild.firstChild.firstChild])[0], editor.body.firstChild.firstChild);
        });

        test('findSuitable tests against node in argument', function() {
            editor.value('<div></div>');
            var finder = new BlockFormatFinder(editor.formats.justifyCenter);

            equal(finder.findSuitable([editor.body.firstChild])[0], editor.body.firstChild);
        });

        test('find format finds formatted node by tag', function() {
            editor.value('<div style="text-align:center">foo</strong>');

            var finder = new BlockFormatFinder(editor.formats.justifyCenter);
            
            equal(finder.findFormat(editor.body.firstChild.firstChild), editor.body.firstChild);
        });

        test('find suitable finds td', function() {
            editor.value('<table><tr><td>foo</td></tr></table>');

            var finder = new BlockFormatFinder(editor.formats.justifyCenter);

            var td = $('td', editor.body)[0];
            equal(finder.findSuitable([td.firstChild])[0], td);
        });

        test('find format returns null if node does not match tag and style', function() {
            editor.value('<div>foo</div>');

            var finder = new BlockFormatFinder(editor.formats.justifyCenter);

            ok(null === finder.findFormat(editor.body.firstChild.firstChild));
        });

        test('find format checks all formats', function() {
            editor.value('<p style="text-align:center">foo</p>');

            var finder = new BlockFormatFinder(editor.formats.justifyCenter);

            equal(finder.findFormat(editor.body.firstChild.firstChild), editor.body.firstChild);
        });
        test('is formatted checks all formats', function() {
            editor.value('<p style="text-align:center">foo</p>');

            var finder = new BlockFormatFinder(editor.formats.justifyCenter);

            ok(finder.isFormatted([editor.body.firstChild.firstChild]));
        });

        test('is formatted returns true if all nodes are formatted', function() {
            editor.value('<div style="text-align:center">foo</div>');

            var finder = new BlockFormatFinder(editor.formats.justifyCenter);
            ok(finder.isFormatted([editor.body.firstChild.firstChild]));
        });

        test('is formatted returns true for formatted and unformatted nodes', function() {
            editor.value('<div style="text-align:center">foo</div>bar');

            var finder = new BlockFormatFinder(editor.formats.justifyCenter);
            ok(!finder.isFormatted([editor.body.firstChild.firstChild, editor.body.lastChild]));
        });

        test('is formatted returns true for image', function() {
            editor.value('<img style="float:right" />');

            var finder = new BlockFormatFinder(editor.formats.justifyRight);
            ok(finder.isFormatted([editor.body.firstChild]));
        });

        test('getFormat on single node', function() {
            editor.value('<h1>foo</h1>');
            var finder = new BlockFormatFinder([{ tags: 'div,p,h1,h2,h3,h4,h5,h6'.split(',') }]);
            equal(finder.getFormat([editor.body.firstChild.firstChild]), 'h1');
        });

        test('getFormat on multiple different nodes', function() {
            editor.value('<h1>foo</h1><h2>bar</h2>');
            var finder = new BlockFormatFinder([{ tags: 'div,p,h1,h2,h3,h4,h5,h6'.split(',') }]);
            equal(finder.getFormat([editor.body.firstChild.firstChild, editor.body.lastChild.firstChild]), '');
        });

        test('getFormat on body does not throw error', function() {
            editor.value('foo');
            var finder = new BlockFormatFinder([{ tags: 'div,p,h1,h2,h3,h4,h5,h6'.split(',') }]);
            equal(finder.getFormat([editor.body]), '');
        });

    </script>

</asp:Content>