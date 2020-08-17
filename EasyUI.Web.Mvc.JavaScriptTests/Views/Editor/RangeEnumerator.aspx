<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>TextNodeIterator</h2>

    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
    
        var editor;

        var RangeEnumerator;
        var enumerator;

        function assertArrayEquals(actual, expected) {
            equal(actual.length, expected.length);

            for (var i = 0; i < expected.length; i++)
                equal(actual[i], expected[i]);
        }

        QUnit.testStart = function() {
            editor = getEditor();
            RangeEnumerator = $.easyui.editor.RangeEnumerator;
        }

        test('enumerate returns text node when all content selected', function() {
            var range = createRangeFromText(editor, '|foo|');
        
            var result = new RangeEnumerator(range).enumerate();

            assertArrayEquals(result, [editor.body.firstChild]);
        });

        test('enumerate returns text nodes when inline node is selected', function() {
            var range = createRangeFromText(editor, '|<span><span>foo</span></span>|');
        
            var result = new RangeEnumerator(range).enumerate();

            assertArrayEquals(result, [editor.body.firstChild.firstChild.firstChild]);
        });

        test('enumerate returns does not return comments', function() {
            var range = createRangeFromText(editor, '|foo<!-- comment -->|');
        
            var result = new RangeEnumerator(range).enumerate();

            assertArrayEquals(result, [editor.body.firstChild]);
        });
    
        test('enumerate returns the text contents when more than one node is selected', function() {
            var range = createRangeFromText(editor, '|<span>foo</span><span>bar</span>|');
        
            var result = new RangeEnumerator(range).enumerate();

            assertArrayEquals(result, [editor.body.firstChild.firstChild, editor.body.lastChild.firstChild]);
        });

        test('enumerate returns the text contents in case of partial selection', function() {
            var range = createRangeFromText(editor, '<span>f|oo</span><span>b|ar</span>');
        
            var result = new RangeEnumerator(range).enumerate();

            assertArrayEquals(result, [editor.body.firstChild.firstChild, editor.body.lastChild.firstChild]);
        });

        test('enumerate skips white space nodes', function() {
            var range = createRangeFromText(editor, '|\r\t<p>test</p>\r\n|');

            var p = $('p', editor.body)[0];
            var result = new RangeEnumerator(range).enumerate();
        
            assertArrayEquals(result, [p.firstChild]);
        });

        test('enumerate returns images', function() {
            var range = createRangeFromText(editor, '|<img />|');
            var result = new RangeEnumerator(range).enumerate();
        
            assertArrayEquals(result, [editor.body.firstChild]);
        });

    </script>

</asp:Content>