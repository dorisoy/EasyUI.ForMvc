<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Exec</h2>

    <%= Html.EasyUI().Editor().Name("Editor1") %>

    <script type="text/javascript">
        function getUndoRedoStack() {
            return new $.easyui.editor.UndoRedoStack();
        }
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">


        
        test('stack is initially empty', function() {
            var undoRedoStack = getUndoRedoStack();

            ok(!undoRedoStack.canUndo());
            ok(!undoRedoStack.canRedo());
        });

        test('canUndo returns true after command is pushed in stack', function() {
            var undoRedoStack = getUndoRedoStack();

            undoRedoStack.push({});

            ok(undoRedoStack.canUndo());
            ok(!undoRedoStack.canRedo());
        });

        test('canRedo returns true after undo', function() {
            var undoRedoStack = getUndoRedoStack();

            undoRedoStack.push({ undo: function() {} });
            undoRedoStack.undo();

            ok(undoRedoStack.canRedo());
        });

        test('canUndo returns false when at the bottom of the stack', function() {
            var undoRedoStack = getUndoRedoStack();

            undoRedoStack.push({ undo: function() {} });
            undoRedoStack.undo();
            
            ok(!undoRedoStack.canUndo());
        });

        test('canRedo returns false when a new command is pushed', function() {
            var undoRedoStack = getUndoRedoStack();

            undoRedoStack.push({ undo: function() {} });
            undoRedoStack.undo();
            undoRedoStack.push({ undo: function() {} });
            
            ok(!undoRedoStack.canRedo());
            ok(undoRedoStack.canUndo());
        });

        test('undo delegates undo to current command', function() {
            var undoRedoStack = getUndoRedoStack();

            var called = false;

            undoRedoStack.push({ undo: function() { called = true; } });
            undoRedoStack.undo();
            
            ok(called);
        });
        
        test('redo delegates to exec to current command', function() {
            var undoRedoStack = getUndoRedoStack();

            var called = false;

            undoRedoStack.push({ undo: function() { }, redo: function() { called = true; } });
            undoRedoStack.undo();
            undoRedoStack.redo();
            
            ok(called);
            ok(!undoRedoStack.canRedo());
            ok(undoRedoStack.canUndo());
        });
        
        test('redo does not delegate to exec when at top of stack', function() {
            var undoRedoStack = getUndoRedoStack();

            var called = false;

            undoRedoStack.push({ undo: function() { }, redo: function() { called = true; } });
            undoRedoStack.redo();
            
            ok(!called);
        });

        test('canUndo is true after undoing the second command', function() {
            var undoRedoStack = getUndoRedoStack();

            undoRedoStack.push({ undo: function() { } });
            undoRedoStack.push({ undo: function() { } });
            undoRedoStack.undo();
            
            ok(undoRedoStack.canUndo());
            
        });

</script>

</asp:Content>