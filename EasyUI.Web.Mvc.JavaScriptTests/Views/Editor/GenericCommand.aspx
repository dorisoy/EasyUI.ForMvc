<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>DeleteCommand</h2>
    <%= Html.EasyUI().Editor().Name("Editor1") %>
    <script type="text/javascript">
        
        var GenericCommand;
        var RestorePoint;

        function getEditor() {
            return $('#Editor1').data("tEditor");
        }
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">


        QUnit.testStart = function() {
            GenericCommand = $.easyui.editor.GenericCommand;
            RestorePoint = $.easyui.editor.RestorePoint;
        }
        
        test('generic command undo returns old contents', function() {
            var editor = getEditor();
            editor.value('foo');
            
            var range = editor.createRange();
            
            range.selectNodeContents(editor.body);

            var startRestorePoint = new RestorePoint(range);
            editor.value('');
            var endRestorePoint = new RestorePoint(range);

            var command = new GenericCommand(startRestorePoint, endRestorePoint);
            command.undo();

            equal(editor.value(), 'foo');
        });

        test('generic command redo sets new contents', function() {
            var editor = getEditor();
            editor.value('foo');

            var range = editor.createRange();

            range.selectNodeContents(editor.body);

            var startRestorePoint = new RestorePoint(range);
            editor.value('');
            var endRestorePoint = new RestorePoint(range);

            var command = new GenericCommand(startRestorePoint, endRestorePoint);
            command.undo();
            command.redo();
            equal(editor.value(), '');
        });

        test('generic command undo restores selection', function() {
            var editor = getEditor();
            editor.value('foo');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 2);
            
            var restorePoint = new RestorePoint(range);
            editor.value('');
            
            var command = new GenericCommand(restorePoint, restorePoint);
            command.undo();
            var selectedRange = editor.getRange();
            equal(selectedRange.startOffset, 1);
            equal(selectedRange.endOffset, 2);
            equal(selectedRange.startContainer, editor.body.firstChild);
            equal(selectedRange.endContainer, editor.body.firstChild);
        });
        
        test('generic command redo restores selection', function() {
            var editor = getEditor();
            editor.value('foo');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 2);
            
            var restorePoint = new RestorePoint(range);
            
            var command = new GenericCommand(restorePoint, restorePoint);
            
            command.redo();
            
            var selectedRange = editor.getRange();
            equal(selectedRange.startOffset, 1);
            equal(selectedRange.endOffset, 2);
            equal(selectedRange.startContainer, editor.body.firstChild);
            equal(selectedRange.endContainer, editor.body.firstChild);
        });

</script>

</asp:Content>