<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        NewLine</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    
    <script type="text/javascript">

        var editor;

        var NewLineCommand;
        var enumerator;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
            NewLineCommand = $.easyui.editor.NewLineCommand;
        }

        test('exec inserts br at carret position', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 1);
            var command = new NewLineCommand({range:range});
            command.exec();
            equal(editor.value(), 'f<br />oo');
        });

        test('exec moves cursor after br', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 1);
            var command = new NewLineCommand({range:range});
            command.exec();
            range = editor.getRange();
            range.insertNode(editor.document.createElement('hr'));
            equal(editor.value(), 'f<br /><hr />oo')
        });

        test('exec replaces selection with br', function() {
            var range = createRangeFromText(editor, 'f|o|o');
            var command = new NewLineCommand({range:range});
            command.exec();
            equal(editor.value(), 'f<br />o');
        });

        test('undo removes br', function() {
            var range = createRangeFromText(editor, 'f|o|o');
            var command = new NewLineCommand({range:range});
            command.exec();
            command.undo();
            equal(editor.value(), 'foo');
        });

        test('undo leaves normalized content', function() {
            var range = createRangeFromText(editor, 'f|o|o');
            var command = new NewLineCommand({range:range});
            command.exec();
            command.undo();
            equal(editor.body.childNodes.length, 1);
        });

        test('redo', function() {
            var range = createRangeFromText(editor, 'f|o|o');
            var command = new NewLineCommand({range:range});
            command.exec();
            command.undo();
            command.exec();
            equal(editor.value(), 'f<br />o');
        });

</script>

</asp:Content>