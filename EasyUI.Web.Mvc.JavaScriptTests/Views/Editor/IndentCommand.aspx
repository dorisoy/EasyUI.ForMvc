<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>IndentCommand</h2>
    
    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    <script type="text/javascript">
        var editor;
        var IndentCommand;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
            IndentCommand = $.easyui.editor.IndentCommand;
        }

        test('exec indents', function() {
            var range = createRangeFromText(editor, '|foo|');
            var command = new IndentCommand({range:range});
            command.exec();
            equal(editor.value(), '<div style="margin-left:30px;">foo</div>');
        });

        test('undo removes margin', function() {
            var range = createRangeFromText(editor, '|foo|');
            var command = new IndentCommand({range:range});
            command.exec();
            command.undo();

            equal(editor.value(), 'foo');
        });
        
        test('redo indents', function() {
            var range = createRangeFromText(editor, '|foo|');
            var command = new IndentCommand({ range: range });
            command.exec();
            command.undo();
            command.exec();

            equal(editor.value(), '<div style="margin-left:30px;">foo</div>');
        });

        test('indent list', function() {
            editor.focus();
            var range = createRangeFromText(editor, '<ul><li>foo</li><li>|b|ar</li></ul>');
            var command = new IndentCommand({ range: range });
            command.exec();
            equal(editor.value(), '<ul><li>foo<ul><li>bar</li></ul></li></ul>');
        });

</script>

</asp:Content>