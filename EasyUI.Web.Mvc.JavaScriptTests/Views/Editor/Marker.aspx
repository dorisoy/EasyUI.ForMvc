<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Marker</h2>

    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

    <script type="text/javascript">
        var FormatCommand, editor, Marker;

        /* helpers */

        function createCollapsedRange(container, offset) {
            var range = editor.createRange();
            range.setStart(container, offset);
            range.setEnd(container, offset);

            return range;
        }

        function createRange(startContainer, startOffset, endContainer, endOffset) {
            var range = editor.createRange();
            range.setStart(startContainer, startOffset);
            range.setEnd(endContainer, endOffset);

            return range;
        }

        /* add/removeMarker tests */
        
        /* add/removeCaretMarker tests */
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
            Marker = $.easyui.editor.Marker;
        }

        test('addMarker inserts markers', function() {
            editor.value('foo');
            
            var range = createRange(editor.body.firstChild, 1, editor.body.firstChild, 2);

            var marker = new Marker();
            marker.add(range);

            equal(editor.value(), 'f<span class="t-marker"></span>o<span class="t-marker"></span>o');
        
        });
        test('addMarker normalizes', function() {
            editor.value('foo');

            var range = createRange(editor.body.firstChild, 0, editor.body.firstChild, 3);

            var marker = new Marker();
            marker.add(range);
            
            ok(editor.body.childNodes.length < 5);
        });

        test('addMarker does not remove line breaks', function() {
            editor.value('foo<br />bar');
            
            var range = createRange(editor.body.firstChild, 0, editor.body.firstChild, 3);

            var marker = new Marker();
            marker.add(range);

            equal(editor.value(), '<span class="t-marker"></span>foo<span class="t-marker"></span><br />bar');
        });

        test('addMarker on collapsed range', function() {
            editor.value('foo');
            
            var range = createCollapsedRange(editor.body.firstChild, 1);

            var marker = new Marker();
            marker.add(range);

            equal(editor.value(), 'f<span class="t-marker"></span><span class="t-marker"></span>oo');
        });
        
        test('removeMarker removes markers', function() {
            var range = createRangeFromText(editor, '|foo|');
            
            var marker = new Marker();
            marker.add(range);
            marker.remove(range);

            equal(editor.value(), 'foo');
        });
        
        test('removeMarker restores range', function() {
            var range = createRangeFromText(editor, '|foo|');

            var marker = new Marker();
            marker.add(range);
            marker.remove(range);
            
            equal(range.startContainer, editor.body.firstChild);
            equal(range.endContainer, editor.body.firstChild);
            equal(range.startOffset, 0);
            equal(range.endOffset, 3);
        });
        
        test('removeMarker normalizes neighbouring text nodes', function() {
            var range = createRangeFromText(editor, 'foo|bar|baz');

            var marker = new Marker();
            marker.add(range);
            marker.remove(range);
            
            equal(editor.body.childNodes.length, 1);
            equal(range.startContainer, editor.body.firstChild);
            equal(range.endContainer, editor.body.firstChild);
            equal(range.startOffset, 3);
            equal(range.endOffset, 6);
        });

        test('removeMarker on collapsed range', function() {
            editor.value('foo');
            var range = createCollapsedRange(editor.body.firstChild, 1);

            var marker = new Marker();
            marker.add(range);
            marker.remove(range);
            
            equal(range.startContainer, editor.body.firstChild);
            equal(range.startOffset, 1);
            equal(range.collapsed, true);
        });

        test('addMarker on collapsed range selects markers', function() {
            editor.value('foo bar');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 3);
            range.collapse(true);
        
            var marker = new $.easyui.editor.Marker();
            range = marker.add(range, true);

            equal(range.startContainer, editor.body);
            equal(range.endContainer, editor.body);
            equal(range.startOffset, 1);
            equal(range.endOffset, 4);
        });

        test('addCaretMarker inserts caret marker', function() {
            editor.value('foo');
            
            var range = createCollapsedRange(editor.body.firstChild, 2);

            var marker = new Marker();
            marker.addCaret(range);

            equal(editor.value(), 'fo<span class="t-marker"></span>o');
        });

        test('addCaretMarker updates range to include caret marker', function() {
            editor.value('foo');
            
            var range = createCollapsedRange(editor.body.firstChild, 2);

            var marker = new Marker();
            marker.addCaret(range);

            equal(range.startContainer, editor.body);
            equal(range.endContainer, editor.body);
            equal(range.startOffset, 1);
            equal(range.endOffset, 2);
        });

        test('removeCaretMarker removes caret marker', function() {
            editor.value('foo');
            
            var range = createRange(editor.body.firstChild, 1, editor.body.firstChild, 2);
            var marker = new Marker();
            marker.addCaret(range);
            marker.removeCaret(range);

            equal(editor.value(), 'foo');
        });

        test('removeCaretMarker normalizes dom', function() {
            editor.value('foo');
            
            var range = createRange(editor.body.firstChild, 1, editor.body.firstChild, 2);
            var marker = new Marker();
            marker.addCaret(range);
            marker.removeCaret(range);

            equal(editor.body.childNodes.length, 1);
        });

        test('removeCaretMarker updates range to collapsed state', function() {
            editor.value('foo');
            
            var range = createRange(editor.body.firstChild, 1, editor.body.firstChild, 2);
            var marker = new Marker();
            marker.addCaret(range);
            marker.removeCaret(range);

            equal(range.startContainer, editor.body.firstChild);
            equal(range.endContainer, editor.body.firstChild);
            equal(range.startOffset, 1);
            equal(range.endOffset, 1);
        });

        test('removeCaretMarker when caret at the beginning', function() {
            editor.value('foo');
            var range = createRange(editor.body.firstChild, 0, editor.body.firstChild, 0);
            
            var marker = new Marker();
            marker.addCaret(range);
            
            editor.body.normalize();

            marker.removeCaret(range);
            
            equal(range.startOffset, 0);
            equal(range.startContainer, editor.body.firstChild);
            ok(range.collapsed);
        });

        test('removeCaretMarker within element', function() {
            editor.value('foo<strong></strong> bar');
            
            var range = createRange(editor.body.childNodes[1], 0, editor.body.childNodes[1], 0);
        
            var marker = new Marker();
            marker.addCaret(range);

            marker.removeCaret(range);
            
            equal(range.startOffset, 0);
            equal(range.startContainer, editor.body.childNodes[1]);
            ok(range.collapsed);
        });

        test('remove marker before br', function() {
            editor.value('<br />');
            var range = editor.getRange();
            range.setStartBefore(editor.body.firstChild);
            range.collapse(true);
            var marker = new Marker();
            marker.addCaret(range);
            marker.removeCaret(range);
            equal(range.startOffset, 0);
            equal(range.startContainer, editor.body);
        });

        test('remove marker after element', function() {
            editor.value('<a></a>');
            var range = editor.getRange();
            range.setEndAfter(editor.body.firstChild);
            range.collapse(false);
            var marker = new Marker();
            marker.add(range);
            
            marker.remove(range);
            equal(range.startOffset, 1);
            equal(range.startContainer, editor.body);
        });

        test('remove caret after element', function() {
            editor.value('<a></a>');
            var range = editor.getRange();
            range.setEndAfter(editor.body.firstChild);
            range.collapse(false);
            var marker = new Marker();
            marker.addCaret(range);
            
            marker.removeCaret(range);
            equal(range.startOffset, 1);
            equal(range.startContainer, editor.body);
        });

        test('remove marker before element', function() {
            editor.value('<a></a>');
            var range = editor.getRange();
            range.setStartBefore(editor.body.firstChild);
            range.collapse(true);
            var marker = new Marker();
            marker.add(range);
            
            marker.remove(range);
            equal(range.startOffset, 0);
            equal(range.startContainer, editor.body);
        });
        
        test('remove caret before element', function() {
            editor.value('<a></a>');
            var range = editor.getRange();
            range.setStartBefore(editor.body.firstChild);
            range.collapse(true);
            var marker = new Marker();
            marker.addCaret(range);

            marker.removeCaret(range);
            equal(range.startOffset, 0);
            equal(range.startContainer, editor.body);
        });

        test('remove caret puts range at end of last text node', function() {
            editor.value('<a>foo</a>');
            var range = editor.getRange();
            range.setStartAfter(editor.body.firstChild);
            range.collapse(true);

            var marker = new Marker();
            marker.addCaret(range);
            marker.removeCaret(range);

            equal(range.startContainer, editor.body.firstChild.firstChild);
            equal(range.startOffset, 3);
            ok(range.collapsed);
        });

        test('remove marker from empty paragraph', function() {
            editor.value('<p>&nbsp;</p>');
            var range = editor.getRange();
            range.selectNodeContents(editor.body.firstChild);
            range.collapse(true);

            var marker = new Marker();
            marker.add(range);
            marker.remove(range);
        });

</script>

</asp:Content>