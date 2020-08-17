<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Selection</h2>

    <%= Html.EasyUI().Editor().Name("Editor") %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

    <script type="text/javascript">
        var editor;
        
        function selectTextNodeContents(node, start, end)
        {
            if (window.getSelection)
            {
                var range = editor.createRange();
                range.setStart(node, start || 0);
                range.setEnd(node, end || node.nodeValue.length);
                editor.getSelection().removeAllRanges();
                editor.getSelection().addRange(range);
            } else {
                var textRange = editor.document.body.createTextRange();
                
                var startPoint = textRange.duplicate();
                startPoint.moveToElementText(node.parentNode);
                if (start)
                    startPoint.moveStart('character', start);
                textRange.setEndPoint('StartToStart', startPoint);

                var endPoint = textRange.duplicate();
                endPoint.moveToElementText(node.parentNode);
                if (end) {
                    endPoint.moveStart('character', end);
                    textRange.setEndPoint('EndToStart', endPoint);
                } else {
                    textRange.setEndPoint('EndToEnd', endPoint);
                }

                textRange.select();
            }
        }

        function selectRange(start, startOffset, end, endOffset, endChars) {
            if (window.getSelection) {
                var range = editor.createRange();
                range.setStart(start, startOffset);
                range.setEnd(end, endOffset);
                var selection = editor.getSelection();
                selection.removeAllRanges();
                selection.addRange(range);
            } else {
                var textRange = editor.document.body.createTextRange();
                
                var startPoint = textRange.duplicate();
                startPoint.moveToElementText(start.parentNode);
                startPoint.moveStart('character', startOffset);
                textRange.setEndPoint('StartToStart', startPoint);

                var endPoint = textRange.duplicate();
                endPoint.moveToElementText(end.parentNode);
                endPoint.moveStart('character', endChars || endOffset);
                textRange.setEndPoint('EndToStart', endPoint);

                textRange.select();
            }
        }

        module('Editor / Selection', {
            setup: function() {
                editor = getEditor();
            }
        });

        test('getSelection returns selection like object', function() {
            var selection = editor.getSelection();

            ok(undefined !== selection);
            ok(undefined !== selection.getRangeAt);
            ok(undefined !== selection.removeAllRanges);
            ok(undefined !== selection.addRange);
        });
        
        test('addRange with text range', function() {
            editor.value('foo');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 2);

            var selection = editor.getSelection();
            
            selection.removeAllRanges();
            selection.addRange(range);
            
            range = editor.getSelection().getRangeAt(0);
            
            equal(range.startOffset, 1);
            equal(range.endOffset, 2);
            equal(range.startContainer, editor.body.firstChild);
            equal(range.endContainer, editor.body.firstChild);
        });
        
        test('addRange with collapsed range', function() {
            editor.value('<strong>golga</strong>frin');

            var range = editor.createRange();
            range.setStart(editor.body.lastChild, 2);
            range.setEnd(editor.body.lastChild, 2);

            var selection = editor.getSelection();
            
            selection.removeAllRanges();
            selection.addRange(range);
            
            range = editor.getSelection().getRangeAt(0);
            
            equal(range.startContainer, editor.body.lastChild);
            equal(range.endContainer, editor.body.lastChild);
            equal(range.startOffset, 2);
            equal(range.endOffset, 2);
        });

        test('addRange with text to element range', function() {
            editor.value('<strong>Haifisch</strong>, der hat Tr�nen');

            var selection = editor.getSelection();
            var range = editor.createRange();
            range.setStart(editor.body.lastChild, 0);
            range.setEnd(editor.body.lastChild, 5);

            selection.removeAllRanges();
            selection.addRange(range);

            range = selection.getRangeAt(0);
            
            equal(range.startOffset, 0);
            equal(range.endOffset, 5);
            equal(range.startContainer, editor.body.lastChild);
            equal(range.endContainer, editor.body.lastChild);
        });

        test('addRange with collapsed range at start of element', function() {
            editor.value('<p>foo</p><p>bar</p>');

            var selection = editor.getSelection();
            var range = editor.createRange();
            range.setStart(editor.body.lastChild.firstChild, 0);
            range.setEnd(editor.body.lastChild.firstChild, 0);

            selection.removeAllRanges();
            selection.addRange(range);

            range = selection.getRangeAt(0);
            
            equal(range.startOffset, 0);
            equal(range.endOffset, 0);
            equal(range.startContainer, editor.body.lastChild.firstChild);
            equal(range.endContainer, editor.body.lastChild.firstChild);
        });

        test('getRangeAt on selection of single text node', function() {
            editor.value('foo');
            var textNode = editor.body.firstChild;
            
            selectTextNodeContents(textNode);

            var range = editor.getSelection().getRangeAt(0);
            
            equal(range.startOffset, 0);
            equal(range.endOffset, 3);
            equal(range.startContainer, textNode);
            equal(range.endContainer, textNode);
        });

        test('getRangeAt on selection of part of text node', function() {
            editor.value('foo');
            var textNode = editor.body.firstChild;
            
            selectTextNodeContents(textNode, 1, 2);
            
            var range = editor.getSelection().getRangeAt(0);
            
            equal(range.startOffset, 1);
            equal(range.endOffset, 2);
            equal(range.startContainer, textNode);
            equal(range.endContainer, textNode);
        });

        test('getRangeAt on selection with end points in text node and tag', function() {
            editor.value('fo<em>obar</em>');

            selectRange(editor.body.firstChild, 1, editor.body.lastChild.firstChild, 2);

            var range = editor.getSelection().getRangeAt(0);
            
            equal(range.startOffset, 1);
            equal(range.endOffset, 2);
            equal(range.startContainer, editor.body.firstChild);
            equal(range.endContainer, editor.body.lastChild.firstChild);
        });

        test('getRangeAt on selection with end points in tag and text node', function() {
            editor.value('<em>foob</em>ar');
            
            selectRange(editor.body.firstChild.firstChild, 2, editor.body.lastChild, 1, 5);
            
            var range = editor.getSelection().getRangeAt(0);
            
            equal(range.startOffset, 2);
            equal(range.endOffset, 1);
            equal(range.startContainer, editor.body.firstChild.firstChild);
            equal(range.endContainer, editor.body.lastChild);
        });

        test('getRangeAt on selection with end points in the middle of different tags', function() {
            editor.value('<em>foo</em><strong>bar</strong>');

            selectRange(editor.body.firstChild.firstChild, 1, editor.body.lastChild.firstChild, 2);
            
            var range = editor.getSelection().getRangeAt(0);
            
            equal(range.startOffset, 1);
            equal(range.endOffset, 2);
            equal(range.startContainer, editor.body.firstChild.firstChild);
            equal(range.endContainer, editor.body.lastChild.firstChild);
        });

        test('getRangeAt on selection with end points in the middle of different text nodes', function() {
            editor.value('fo<em>ob</em>ar');
            
            selectRange(editor.body.firstChild, 1, editor.body.lastChild, 1, 5);
            
            var range = editor.getSelection().getRangeAt(0);
            
            equal(range.startOffset, 1);
            equal(range.endOffset, 1);
            equal(range.startContainer, editor.body.firstChild);
            equal(range.endContainer, editor.body.lastChild);
        });

        test('getRangeAt on collapsed selection at end of paragraph', function() {
            editor.value('<p>foo</p>');
            
            var selection = editor.getSelection(),
                range = editor.createRange();

            range.setStart(editor.body.firstChild.firstChild, 3);
            range.collapse(true);

            selection.removeAllRanges();
            selection.addRange(range);

            range = selection.getRangeAt(0);
            
            ok(range.collapsed);
            equal(range.startOffset, 3);
            equal(range.startContainer, editor.body.firstChild.firstChild);
        });

</script>

</asp:Content>