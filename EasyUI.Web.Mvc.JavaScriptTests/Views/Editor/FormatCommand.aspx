<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Exec</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    
    <script type="text/javascript">
        var FormatCommand, impl, editor;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">




        QUnit.testStart = function() {
            editor = getEditor();
            FormatCommand = $.easyui.editor.FormatCommand;
        }
        
        test('undo restores original content', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);

            var command = editor.tools['bold'].command({range:range});
            command.exec();
            equal(editor.value(), '<strong>foo</strong>');
            command.undo();
            equal(editor.value(), 'foo');
        });

        test('undo restores selection', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 2);

            var command = editor.tools['bold'].command({range:range});
            command.exec();
            command.undo();

            var selectionRange = editor.getRange();
            equal(selectionRange.startOffset, 1);
            equal(selectionRange.endOffset, 2);
            equal(selectionRange.startContainer, editor.body.firstChild);
            equal(selectionRange.endContainer, editor.body.firstChild);
        });

        test('redo executes the command', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);

            var command = editor.tools['bold'].command({range:range});
            command.exec();
            equal(editor.value(), '<strong>foo</strong>');
            command.undo();
            equal(editor.value(), 'foo');
            command.exec();
            equal(editor.value(), '<strong>foo</strong>');
        });

        test('fontName exec', function() {
            var range = createRangeFromText(editor, '|foo|');
            editor.selectRange(range);
            editor.exec('fontName', {value: 'Arial'});
            equal(editor.value(), '<span style="font-family:Arial;">foo</span>');
        });        
        
        test('fontSize exec', function() {
            var range = createRangeFromText(editor, '|foo|');
            editor.selectRange(range);
            editor.exec('fontSize', {value: '8pt'});
            equal(editor.value(), '<span style="font-size:8pt;">foo</span>');
        });        
        
        test('foreColor exec', function() {
            var range = createRangeFromText(editor, '|foo|');
            editor.selectRange(range);
            editor.exec('foreColor', {value: '#a0b0c0'});
            equal(editor.value(), '<span style="color:#a0b0c0;">foo</span>');
        });        
        
        test('backColor exec', function() {
            var range = createRangeFromText(editor, '|foo|');
            editor.selectRange(range);
            editor.exec('backColor', {value: '#a0b0c0'});
            equal(editor.value(), '<span style="background-color:#a0b0c0;">foo</span>');
        });

</script>

</asp:Content>